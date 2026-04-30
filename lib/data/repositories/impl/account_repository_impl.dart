import 'package:fin_sage/data/datasources/local/local_database_datasource.dart';
import 'package:fin_sage/data/models/account_model.dart';
import 'package:fin_sage/data/repositories/account_repository.dart';

class AccountRepositoryImpl implements AccountRepository {
  AccountRepositoryImpl(this._local);

  final LocalDatabaseDataSource _local;

  @override
  Future<List<AccountModel>> getAccounts() => _local.getAccounts();

  @override
  Future<void> saveAccount(AccountModel account) => _local.saveAccount(account);

  @override
  Future<void> updateAccount(AccountModel account) =>
      _local.updateAccount(account);

  @override
  Future<void> archiveAccount(int accountId) =>
      _local.archiveAccount(accountId);

  @override
  Future<void> updateBalance(
          {required int accountId, required double amount}) =>
      _local.adjustAccountBalance(accountId: accountId, amount: amount);
}
