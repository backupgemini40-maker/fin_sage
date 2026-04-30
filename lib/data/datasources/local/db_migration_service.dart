import 'package:sqflite_sqlcipher/sqflite.dart';

class DbMigrationService {
  static const int schemaVersion = 5;

  Future<void> createLatestSchema(Database db) async {
    await _createV1Schema(db);
    await _upgradeToV2(db);
    await _upgradeToV3(db);
    await _upgradeToV4(db);
    await _upgradeToV5(db);
  }

  Future<void> upgrade(Database db, int oldVersion, int newVersion) async {
    for (int version = oldVersion + 1; version <= newVersion; version++) {
      switch (version) {
        case 2:
          await _upgradeToV2(db);
          break;
        case 3:
          await _upgradeToV3(db);
          break;
        case 4:
          await _upgradeToV4(db);
          break;
        case 5:
          await _upgradeToV5(db);
          break;
        default:
          break;
      }
    }
  }

  Future<void> _createV1Schema(Database db) async {
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        color_hex TEXT NOT NULL,
        icon TEXT NOT NULL DEFAULT 'wallet'
      )
    ''');

    // transaction table is created in v3

    await db.execute('''
      CREATE TABLE budgets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category_id INTEGER NOT NULL,
        month TEXT NOT NULL,
        limit_amount REAL NOT NULL,
        used_amount REAL NOT NULL DEFAULT 0,
        FOREIGN KEY(category_id) REFERENCES categories(id)
      )
    ''');

    await db.insert('categories', {
      'name': 'General',
      'color_hex': '#0D3B66',
      'icon': 'wallet',
    });
  }

  Future<void> _upgradeToV2(Database db) async {
    final columns = await db.rawQuery('PRAGMA table_info(categories)');
    final hasArchived = columns.any((row) => row['name'] == 'is_archived');
    if (hasArchived) {
      return;
    }

    await db.execute(
        'ALTER TABLE categories ADD COLUMN is_archived INTEGER NOT NULL DEFAULT 0');
  }

  Future<void> _upgradeToV3(Database db) async {
    await db.execute('''
      CREATE TABLE accounts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        balance REAL NOT NULL,
        icon TEXT NOT NULL DEFAULT 'wallet',
        color_hex TEXT NOT NULL,
        is_archived INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.insert('accounts', {
      'name': 'Primary',
      'type': 'Cash',
      'balance': 0.0,
      'color_hex': '#4F8FC0',
      'icon': 'account_balance_wallet',
    });

    try {
      // V1 schema had a transactions table, but to add a foreign key,
      // the simplest approach in sqlite is to rename, create, and copy.
      await db.execute('ALTER TABLE transactions RENAME TO transactions_old');
    } on DatabaseException catch (e) {
      // The table might not exist if this is a fresh install.
      if (!e.toString().contains('no such table: transactions')) {
        rethrow;
      }
    }

    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        category_id INTEGER NOT NULL,
        account_id INTEGER NOT NULL,
        type TEXT NOT NULL,
        FOREIGN KEY(category_id) REFERENCES categories(id),
        FOREIGN KEY(account_id) REFERENCES accounts(id)
      )
    ''');

    final transactionsExist = await db.rawQuery(
      'SELECT name FROM sqlite_master WHERE type="table" AND name="transactions_old"',
    );

    if (transactionsExist.isNotEmpty) {
      final defaultAccountId = 1;
      await db.execute('''
        INSERT INTO transactions (id, title, amount, date, category_id, type, account_id)
        SELECT id, title, amount, date, category_id, type, $defaultAccountId
        FROM transactions_old
      ''');
      await db.execute('DROP TABLE transactions_old');
    }
  }

  Future<void> _upgradeToV4(Database db) async {
    await db.execute('''
      CREATE TABLE recurring_transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        type TEXT NOT NULL,
        recurrence_rule TEXT NOT NULL,
        next_occurrence_date TEXT NOT NULL,
        category_id INTEGER NOT NULL,
        account_id INTEGER NOT NULL,
        FOREIGN KEY(category_id) REFERENCES categories(id),
        FOREIGN KEY(account_id) REFERENCES accounts(id)
      )
    ''');
  }

  Future<void> _upgradeToV5(Database db) async {
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_transactions_date ON transactions(date)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_transactions_category ON transactions(category_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_transactions_account ON transactions(account_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_budgets_month ON budgets(month)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_recurring_next_date ON recurring_transactions(next_occurrence_date)',
    );
  }
}
