import 'package:fin_sage/data/models/account_model.dart';
import 'package:fin_sage/data/repositories/account_repository.dart';
import 'package:fin_sage/core/errors/error_mapper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  AccountCubit(this._accountRepository) : super(AccountInitial());

  final AccountRepository _accountRepository;

  Future<void> loadAccounts() async {
    try {
      emit(AccountLoading());
      final accounts = await _accountRepository.getAccounts();
      emit(AccountLoaded(accounts));
    } catch (e) {
      emit(AccountError(mapErrorMessage(e)));
    }
  }

  Future<bool> saveAccount(AccountModel account) async {
    try {
      await _accountRepository.saveAccount(account);
      await loadAccounts();
      return true;
    } catch (e) {
      emit(AccountError(mapErrorMessage(e)));
      return false;
    }
  }

  Future<bool> updateAccount(AccountModel account) async {
    try {
      await _accountRepository.updateAccount(account);
      await loadAccounts();
      return true;
    } catch (e) {
      emit(AccountError(mapErrorMessage(e)));
      return false;
    }
  }

  Future<bool> archiveAccount(int accountId) async {
    final previousAccounts =
        state is AccountLoaded ? (state as AccountLoaded).accounts : null;
    try {
      await _accountRepository.archiveAccount(accountId);
      await loadAccounts();
      return true;
    } catch (e) {
      final message = mapErrorMessage(e);
      if (previousAccounts != null) {
        emit(AccountLoaded(previousAccounts, error: message));
      } else {
        emit(AccountError(message));
      }
      return false;
    }
  }
}
