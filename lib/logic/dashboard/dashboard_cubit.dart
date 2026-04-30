import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:fin_sage/core/errors/error_mapper.dart';
import 'package:fin_sage/data/models/account_model.dart';
import 'package:fin_sage/data/models/transaction_model.dart';
import 'package:fin_sage/data/repositories/account_repository.dart';
import 'package:fin_sage/data/repositories/transaction_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BalanceTrendPoint extends Equatable {
  const BalanceTrendPoint({
    required this.date,
    required this.balance,
  });

  final DateTime date;
  final double balance;

  @override
  List<Object> get props => [date, balance];
}

class DashboardState extends Equatable {
  const DashboardState({
    this.loading = false,
    this.income = 0,
    this.expense = 0,
    this.totalBalance = 0,
    this.recentTransactions = const [],
    this.accounts = const [],
    this.balanceTrend = const [],
    this.monthlyTransactionCount = 0,
    this.error,
  });

  final bool loading;
  final double income;
  final double expense;
  final double totalBalance;
  final List<TransactionModel> recentTransactions;
  final List<AccountModel> accounts;
  final List<BalanceTrendPoint> balanceTrend;
  final int monthlyTransactionCount;
  final String? error;

  DashboardState copyWith({
    bool? loading,
    double? income,
    double? expense,
    double? totalBalance,
    List<TransactionModel>? recentTransactions,
    List<AccountModel>? accounts,
    List<BalanceTrendPoint>? balanceTrend,
    int? monthlyTransactionCount,
    String? error,
  }) {
    return DashboardState(
      loading: loading ?? this.loading,
      income: income ?? this.income,
      expense: expense ?? this.expense,
      totalBalance: totalBalance ?? this.totalBalance,
      recentTransactions: recentTransactions ?? this.recentTransactions,
      accounts: accounts ?? this.accounts,
      balanceTrend: balanceTrend ?? this.balanceTrend,
      monthlyTransactionCount:
          monthlyTransactionCount ?? this.monthlyTransactionCount,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        loading,
        income,
        expense,
        totalBalance,
        recentTransactions,
        accounts,
        balanceTrend,
        monthlyTransactionCount,
        error,
      ];
}

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this._repo, this._accountRepository)
      : super(const DashboardState());

  final TransactionRepository _repo;
  final AccountRepository _accountRepository;

  Future<void> loadOverview() async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final result = await Future.wait([
        _repo.monthlySummary(),
        _repo.fetchTransactions(),
        _accountRepository.getAccounts(),
      ]);
      final summary = result[0] as Map<String, double>;
      final transactions = result[1] as List<TransactionModel>;
      final accounts = result[2] as List<AccountModel>;

      final totalBalance =
          accounts.fold<double>(0, (sum, account) => sum + account.balance);

      final now = DateTime.now();
      final monthlyTransactions = transactions
          .where((tx) => tx.date.year == now.year && tx.date.month == now.month)
          .toList();
      final monthlyCount = monthlyTransactions.length;
      final balanceTrend = _buildMonthlyBalanceTrend(monthlyTransactions);

      emit(
        state.copyWith(
          loading: false,
          income: summary['income'] ?? 0,
          expense: summary['expense'] ?? 0,
          totalBalance: totalBalance,
          recentTransactions: transactions.take(5).toList(),
          accounts: accounts.take(4).toList(),
          balanceTrend: balanceTrend,
          monthlyTransactionCount: monthlyCount,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loading: false, error: mapErrorMessage(e)));
    }
  }

  List<BalanceTrendPoint> _buildMonthlyBalanceTrend(
      List<TransactionModel> monthlyTransactions) {
    if (monthlyTransactions.isEmpty) {
      return const [];
    }

    final dailyNet = SplayTreeMap<DateTime, double>();
    for (final tx in monthlyTransactions) {
      final day = DateTime(tx.date.year, tx.date.month, tx.date.day);
      final amount = tx.type == TransactionType.income ? tx.amount : -tx.amount;
      dailyNet.update(day, (value) => value + amount, ifAbsent: () => amount);
    }

    var runningBalance = 0.0;
    final points = <BalanceTrendPoint>[];
    for (final entry in dailyNet.entries) {
      runningBalance += entry.value;
      points.add(BalanceTrendPoint(date: entry.key, balance: runningBalance));
    }
    return points;
  }
}
