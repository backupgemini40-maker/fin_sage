import 'package:fin_sage/data/models/account_model.dart';

abstract class AccountRepository {
  Future<List<AccountModel>> getAccounts();
  Future<void> saveAccount(AccountModel account);
  Future<void> updateAccount(AccountModel account);
  Future<void> archiveAccount(int accountId);
  Future<void> updateBalance({required int accountId, required double amount});
}
