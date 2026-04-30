import 'package:fin_sage/data/datasources/local/local_database_datasource.dart';
import 'package:fin_sage/data/models/recurring_transaction_model.dart';
import 'package:fin_sage/data/repositories/recurring_transaction_repository.dart';

class RecurringTransactionRepositoryImpl
    implements RecurringTransactionRepository {
  RecurringTransactionRepositoryImpl(this._local);

  final LocalDatabaseDataSource _local;

  @override
  Future<List<RecurringTransactionModel>> getRecurringTransactions() =>
      _local.getRecurringTransactions();

  @override
  Future<void> saveRecurringTransaction(RecurringTransactionModel transaction) =>
      _local.saveRecurringTransaction(transaction);

  @override
  Future<void> updateRecurringTransaction(
          RecurringTransactionModel transaction) =>
      _local.updateRecurringTransaction(transaction);

  @override
  Future<void> deleteRecurringTransaction(int transactionId) =>
      _local.deleteRecurringTransaction(transactionId);
}
