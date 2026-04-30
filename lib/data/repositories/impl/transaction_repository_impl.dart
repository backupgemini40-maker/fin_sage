import 'package:fin_sage/data/datasources/local/drift_query_service.dart';
import 'package:fin_sage/data/datasources/local/local_database_datasource.dart';
import 'package:fin_sage/data/models/category_model.dart';
import 'package:fin_sage/data/models/transaction_model.dart';
import 'package:fin_sage/data/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  TransactionRepositoryImpl(this._local, this._drift);

  final LocalDatabaseDataSource _local;
  final DriftQueryService _drift;

  @override
  Future<List<TransactionModel>> fetchTransactions() =>
      _local.getTransactions();

  @override
  Future<List<CategoryModel>> fetchCategories() => _local.getCategories();

  @override
  Future<void> saveCategory(CategoryModel category) =>
      _local.saveCategory(category);

  @override
  Future<void> archiveCategory(int categoryId) =>
      _local.archiveCategory(categoryId);

  @override
  Future<void> saveTransaction(TransactionModel transaction) =>
      _local.saveTransactionWithBalance(transaction);

  @override
  Future<void> updateTransaction(TransactionModel transaction) =>
      _local.updateTransactionWithBalance(transaction);

  @override
  Future<void> deleteTransaction(int transactionId) =>
      _local.deleteTransactionWithBalance(transactionId);

  @override
  Future<Map<String, double>> monthlySummary() => _drift.monthlySummary();

  @override
  Future<void> recoverCorruptedDatabase() => _local.purgeEncryptedDatabase();
}
