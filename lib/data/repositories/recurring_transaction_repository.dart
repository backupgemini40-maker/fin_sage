import 'package:fin_sage/data/models/recurring_transaction_model.dart';

abstract class RecurringTransactionRepository {
  Future<List<RecurringTransactionModel>> getRecurringTransactions();
  Future<void> saveRecurringTransaction(RecurringTransactionModel transaction);
  Future<void> updateRecurringTransaction(RecurringTransactionModel transaction);
  Future<void> deleteRecurringTransaction(int transactionId);
}
