import 'dart:io';

import 'package:fin_sage/core/constants/app_constants.dart';
import 'package:fin_sage/core/errors/app_exception.dart';
import 'package:fin_sage/core/errors/app_error_codes.dart';
import 'package:fin_sage/data/datasources/local/db_migration_service.dart';
import 'package:fin_sage/data/datasources/local/secure_key_service.dart';
import 'package:fin_sage/data/models/recurring_transaction_model.dart';
import 'package:fin_sage/data/models/account_model.dart';
import 'package:fin_sage/data/models/budget_model.dart';
import 'package:fin_sage/data/models/category_model.dart';
import 'package:fin_sage/data/models/transaction_model.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_sqlcipher/sqflite.dart';

class LocalDatabaseDataSource {
  LocalDatabaseDataSource(this._secureKeyService, this._migrationService);

  final SecureKeyService _secureKeyService;
  final DbMigrationService _migrationService;
  Database? _db;

  Future<Database> _database() async {
    if (_db != null) {
      return _db!;
    }

    final folder = await getDatabasesPath();
    await Directory(folder).create(recursive: true);
    final dbPath = p.join(folder, AppConstants.dbName);
    final dbFile = File(dbPath);
    final dbExists = await dbFile.exists();

    var key = await _secureKeyService.readDbKey();
    if ((key == null || key.isEmpty) && dbExists) {
      throw const AppException(
        'Failed to open encrypted local database: encryption key unavailable for existing database file.',
        code: AppErrorCodes.databaseOpenFailed,
      );
    }
    key ??= await _secureKeyService.createDbKey();

    try {
      _db = await openDatabase(
        dbPath,
        password: key,
        version: DbMigrationService.schemaVersion,
        onCreate: (db, version) async =>
            _migrationService.createLatestSchema(db),
        onUpgrade: (db, oldVersion, newVersion) async =>
            _migrationService.upgrade(db, oldVersion, newVersion),
      );
    } on DatabaseException catch (e) {
      throw AppException(
        'Failed to open encrypted local database: ${e.toString()}',
        code: AppErrorCodes.databaseOpenFailed,
      );
    }

    return _db!;
  }

  Future<String> databasePath() async {
    final folder = await getDatabasesPath();
    return p.join(folder, AppConstants.dbName);
  }

  Future<List<int>> databaseBytes() async {
    await _database();
    final file = File(await databasePath());
    return file.readAsBytes();
  }

  Future<List<TransactionModel>> getTransactions() async {
    final db = await _database();
    final rows = await db.query('transactions', orderBy: 'date DESC');
    return rows.map(TransactionModel.fromMap).toList();
  }

  Future<void> saveTransaction(TransactionModel transaction) async {
    final db = await _database();
    await db.insert('transactions', transaction.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> saveTransactionWithBalance(TransactionModel transaction) async {
    final db = await _database();
    await db.transaction((txn) async {
      await txn.insert(
        'transactions',
        transaction.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      await _adjustAccountBalanceInTransaction(
        txn,
        accountId: transaction.accountId,
        amount: _signedTransactionAmount(transaction),
      );
    });
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    if (transaction.id == null) {
      throw ArgumentError('Transaction id is required for update');
    }
    final db = await _database();
    await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<void> updateTransactionWithBalance(
      TransactionModel transaction) async {
    if (transaction.id == null) {
      throw ArgumentError('Transaction id is required for update');
    }

    final db = await _database();
    await db.transaction((txn) async {
      final existingRows = await txn.query(
        'transactions',
        where: 'id = ?',
        whereArgs: [transaction.id],
        limit: 1,
      );
      if (existingRows.isEmpty) {
        throw const AppException(
          'Transaction not found',
          code: AppErrorCodes.unexpectedError,
        );
      }

      final existing = TransactionModel.fromMap(existingRows.first);
      await _adjustAccountBalanceInTransaction(
        txn,
        accountId: existing.accountId,
        amount: -_signedTransactionAmount(existing),
      );

      final updated = await txn.update(
        'transactions',
        transaction.toMap(),
        where: 'id = ?',
        whereArgs: [transaction.id],
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
      if (updated != 1) {
        throw const AppException(
          'Transaction update failed',
          code: AppErrorCodes.unexpectedError,
        );
      }

      await _adjustAccountBalanceInTransaction(
        txn,
        accountId: transaction.accountId,
        amount: _signedTransactionAmount(transaction),
      );
    });
  }

  Future<void> deleteTransaction(int transactionId) async {
    final db = await _database();
    await db
        .delete('transactions', where: 'id = ?', whereArgs: [transactionId]);
  }

  Future<void> deleteTransactionWithBalance(int transactionId) async {
    final db = await _database();
    await db.transaction((txn) async {
      final existingRows = await txn.query(
        'transactions',
        where: 'id = ?',
        whereArgs: [transactionId],
        limit: 1,
      );
      if (existingRows.isEmpty) {
        throw const AppException(
          'Transaction not found',
          code: AppErrorCodes.unexpectedError,
        );
      }

      final existing = TransactionModel.fromMap(existingRows.first);
      final deleted = await txn.delete(
        'transactions',
        where: 'id = ?',
        whereArgs: [transactionId],
      );
      if (deleted != 1) {
        throw const AppException(
          'Transaction delete failed',
          code: AppErrorCodes.unexpectedError,
        );
      }

      await _adjustAccountBalanceInTransaction(
        txn,
        accountId: existing.accountId,
        amount: -_signedTransactionAmount(existing),
      );
    });
  }

  Future<void> adjustAccountBalance({
    required int accountId,
    required double amount,
  }) async {
    final db = await _database();
    await db.transaction((txn) async {
      await _adjustAccountBalanceInTransaction(
        txn,
        accountId: accountId,
        amount: amount,
      );
    });
  }

  Future<List<CategoryModel>> getCategories() async {
    final db = await _database();
    final rows = await db.query(
      'categories',
      where: 'is_archived = ?',
      whereArgs: [0],
      orderBy: 'name ASC',
    );
    return rows.map(CategoryModel.fromMap).toList();
  }

  Future<void> saveCategory(CategoryModel category) async {
    final db = await _database();
    final normalizedName = category.name.trim().toLowerCase();
    final existing = await db.query(
      'categories',
      where: 'lower(name) = ?',
      whereArgs: [normalizedName],
      limit: 1,
    );
    if (existing.isNotEmpty) {
      throw const AppException(
        'Category already exists',
        code: AppErrorCodes.categoryAlreadyExists,
      );
    }

    await db.insert('categories', category.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort);
  }

  Future<void> archiveCategory(int categoryId) async {
    if (categoryId == 1) {
      throw const AppException(
        'Default category cannot be archived',
        code: AppErrorCodes.defaultCategoryArchiveBlocked,
      );
    }

    final db = await _database();
    final usage = await db.rawQuery(
      'SELECT COUNT(*) AS total FROM transactions WHERE category_id = ?',
      [categoryId],
    );
    final usedCount = (usage.first['total'] as num?)?.toInt() ?? 0;
    if (usedCount > 0) {
      throw const AppException(
        'Category is still used by transactions',
        code: AppErrorCodes.categoryInUse,
      );
    }

    await db.update(
      'categories',
      {'is_archived': 1},
      where: 'id = ?',
      whereArgs: [categoryId],
    );
  }

  Future<List<BudgetModel>> getBudgets() async {
    final db = await _database();
    final rows = await db.query('budgets', orderBy: 'month DESC');
    return rows.map(BudgetModel.fromMap).toList();
  }

  Future<void> saveBudget(BudgetModel budget) async {
    final db = await _database();
    await db.insert('budgets', budget.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteBudget(int budgetId) async {
    final db = await _database();
    await db.delete('budgets', where: 'id = ?', whereArgs: [budgetId]);
  }

  Future<List<RecurringTransactionModel>> getRecurringTransactions() async {
    final db = await _database();
    final rows = await db.query('recurring_transactions',
        orderBy: 'next_occurrence_date ASC');
    return rows.map(RecurringTransactionModel.fromMap).toList();
  }

  Future<void> saveRecurringTransaction(
      RecurringTransactionModel transaction) async {
    final db = await _database();
    await db.insert('recurring_transactions', transaction.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateRecurringTransaction(
      RecurringTransactionModel transaction) async {
    if (transaction.id == null) {
      throw ArgumentError('Recurring transaction id is required for update');
    }
    final db = await _database();
    await db.update(
      'recurring_transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<void> deleteRecurringTransaction(int transactionId) async {
    final db = await _database();
    await db.delete('recurring_transactions',
        where: 'id = ?', whereArgs: [transactionId]);
  }

  Future<List<AccountModel>> getAccounts() async {
    final db = await _database();
    final rows = await db.query(
      'accounts',
      where: 'is_archived = ?',
      whereArgs: [0],
      orderBy: 'name ASC',
    );
    return rows.map(AccountModel.fromMap).toList();
  }

  Future<void> saveAccount(AccountModel account) async {
    final db = await _database();
    final normalizedName = account.name.trim().toLowerCase();
    final existing = await db.query(
      'accounts',
      where: 'lower(name) = ?',
      whereArgs: [normalizedName],
      limit: 1,
    );
    if (existing.isNotEmpty) {
      throw const AppException(
        'Account already exists',
        code: AppErrorCodes.accountAlreadyExists,
      );
    }

    await db.insert('accounts', account.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort);
  }

  Future<void> updateAccount(AccountModel account) async {
    if (account.id == null) {
      throw ArgumentError('Account id is required for update');
    }
    final db = await _database();
    await db.update(
      'accounts',
      account.toMap(),
      where: 'id = ?',
      whereArgs: [account.id],
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<void> archiveAccount(int accountId) async {
    if (accountId == 1) {
      throw const AppException(
        'Default account cannot be archived',
        code: AppErrorCodes.defaultAccountArchiveBlocked,
      );
    }

    final db = await _database();
    final rows = await db.query(
      'accounts',
      columns: ['balance'],
      where: 'id = ?',
      whereArgs: [accountId],
      limit: 1,
    );
    if (rows.isEmpty) {
      throw const AppException(
        'Account not found',
        code: AppErrorCodes.accountNotFound,
      );
    }
    final balance = (rows.first['balance'] as num?)?.toDouble() ?? 0;
    if (balance.abs() > 0.005) {
      throw const AppException(
        'Account balance must be zero before archiving',
        code: AppErrorCodes.accountBalanceNotZero,
      );
    }

    await db.update(
      'accounts',
      {'is_archived': 1},
      where: 'id = ?',
      whereArgs: [accountId],
    );
  }

  double _signedTransactionAmount(TransactionModel transaction) {
    return transaction.type == TransactionType.income
        ? transaction.amount
        : -transaction.amount;
  }

  Future<void> _adjustAccountBalanceInTransaction(
    Transaction txn, {
    required int accountId,
    required double amount,
  }) async {
    final updated = await txn.rawUpdate(
      'UPDATE accounts SET balance = balance + ? WHERE id = ?',
      [amount, accountId],
    );
    if (updated != 1) {
      throw const AppException(
        'Account not found',
        code: AppErrorCodes.accountNotFound,
      );
    }
  }

  Future<void> replaceDatabaseFile(List<int> bytes) async {
    final activeDb = _db;
    _db = null;
    await activeDb?.close();

    final path = await databasePath();
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
    await file.writeAsBytes(bytes, flush: true);
  }

  Future<void> resetLocalData() async {
    final db = await _database();
    await db.transaction((txn) async {
      await txn.delete('transactions');
      await txn.delete('budgets');
      await txn.delete('categories');
      await txn.delete('accounts');
      await txn.delete('recurring_transactions');
      await txn.insert('categories', {
        'name': 'General',
        'color_hex': '#0D3B66',
        'icon': 'wallet',
        'is_archived': 0,
      });
      await txn.insert('accounts', {
        'name': 'Primary',
        'type': 'Cash',
        'balance': 0.0,
        'color_hex': '#4F8FC0',
        'icon': 'account_balance_wallet',
      });
    });
  }

  Future<Map<String, double>> monthlySummary() async {
    final db = await _database();
    final now = DateTime.now();
    final monthPrefix =
        '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}';
    final rows = await db.rawQuery('''
      SELECT
        SUM(CASE WHEN type = 'income' THEN amount ELSE 0 END) AS income,
        SUM(CASE WHEN type = 'expense' THEN amount ELSE 0 END) AS expense
      FROM transactions
      WHERE substr(date, 1, 7) = ?
    ''', [monthPrefix]);

    if (rows.isEmpty) {
      return {'income': 0, 'expense': 0};
    }

    final row = rows.first;
    final income = (row['income'] as num?)?.toDouble() ?? 0;
    final expense = (row['expense'] as num?)?.toDouble() ?? 0;
    return {'income': income, 'expense': expense};
  }

  Future<void> purgeEncryptedDatabase() async {
    final activeDb = _db;
    _db = null;
    await activeDb?.close();

    final path = await databasePath();
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
    await _secureKeyService.deleteDbKey();
  }
}
