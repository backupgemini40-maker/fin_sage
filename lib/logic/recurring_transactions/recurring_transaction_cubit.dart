import 'package:equatable/equatable.dart';
import 'package:fin_sage/data/models/recurring_transaction_model.dart';
import 'package:fin_sage/data/repositories/recurring_transaction_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'recurring_transaction_state.dart';

class RecurringTransactionCubit extends Cubit<RecurringTransactionState> {
  RecurringTransactionCubit(this._repo) : super(RecurringTransactionInitial());

  final RecurringTransactionRepository _repo;

  Future<void> loadRecurringTransactions() async {
    try {
      emit(RecurringTransactionLoading());
      final transactions = await _repo.getRecurringTransactions();
      emit(RecurringTransactionLoaded(transactions));
    } catch (e) {
      emit(RecurringTransactionError(e.toString()));
    }
  }

  Future<void> saveRecurringTransaction(
      RecurringTransactionModel transaction) async {
    try {
      await _repo.saveRecurringTransaction(transaction);
      loadRecurringTransactions();
    } catch (e) {
      emit(RecurringTransactionError(e.toString()));
    }
  }

  Future<void> updateRecurringTransaction(
      RecurringTransactionModel transaction) async {
    try {
      await _repo.updateRecurringTransaction(transaction);
      loadRecurringTransactions();
    } catch (e) {
      emit(RecurringTransactionError(e.toString()));
    }
  }

  Future<void> deleteRecurringTransaction(int transactionId) async {
    try {
      await _repo.deleteRecurringTransaction(transactionId);
      loadRecurringTransactions();
    } catch (e) {
      emit(RecurringTransactionError(e.toString()));
    }
  }
}
