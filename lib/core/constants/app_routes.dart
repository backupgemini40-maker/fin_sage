import 'package:fin_sage/data/models/account_model.dart';
import 'package:fin_sage/data/models/recurring_transaction_model.dart';
import 'package:fin_sage/features/transactions/add_edit_recurring_transaction_page.dart';
import 'package:fin_sage/features/accounts/add_edit_account_page.dart';
import 'package:fin_sage/features/accounts/accounts_page.dart';
import 'package:fin_sage/features/auth/auth_page.dart';
import 'package:fin_sage/features/auth/auth_gate_page.dart';
import 'package:fin_sage/features/budgets/budgets_page.dart';
import 'package:fin_sage/features/dashboard/dashboard_page.dart';
import 'package:fin_sage/features/recovery/recovery_page.dart';
import 'package:fin_sage/features/reports/reports_page.dart';
import 'package:fin_sage/features/settings/settings_page.dart';
import 'package:fin_sage/core/di/service_locator.dart';
import 'package:fin_sage/features/transactions/recurring_transactions_page.dart';
import 'package:fin_sage/features/transactions/transaction_categories_page.dart';
import 'package:fin_sage/features/transactions/transactions_page.dart';
import 'package:fin_sage/logic/accounts/account_cubit.dart';
import 'package:fin_sage/logic/recurring_transactions/recurring_transaction_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRoutes {
  static const String root = '/';
  static const String auth = '/auth';
  static const String dashboard = '/dashboard';
  static const String transactions = '/transactions';
  static const String transactionCategories = '/transactions/categories';
  static const String accounts = '/accounts';
  static const String addEditAccount = '/accounts/add_edit';
  static const String budgets = '/budgets';
  static const String reports = '/reports';
  static const String settingsRoute = '/settings';
  static const String recurringTransactions = '/settings/recurring';
  static const String addEditRecurringTransaction =
      '/settings/recurring/add_edit';
  static const String recovery = '/recovery';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case root:
        return _material(const AuthGatePage(), settings);
      case auth:
        return _material(const AuthPage(), settings);
      case dashboard:
        return _material(const DashboardPage(), settings);
      case transactions:
        return _material(const TransactionsPage(), settings);
      case transactionCategories:
        return _material(const TransactionCategoriesPage(), settings);
      case accounts:
        return _material(const AccountsPage(), settings);
      case addEditAccount:
        final account = settings.arguments as AccountModel?;
        return _material(
          BlocProvider(
            create: (_) => sl<AccountCubit>(),
            child: AddEditAccountPage(account: account),
          ),
          settings,
        );
      case budgets:
        return _material(const BudgetsPage(), settings);
      case reports:
        return _material(const ReportsPage(), settings);
      case settingsRoute:
        return _material(const SettingsPage(), settings);
      case recurringTransactions:
        return _material(const RecurringTransactionsPage(), settings);
      case addEditRecurringTransaction:
        final transaction = settings.arguments as RecurringTransactionModel?;
        return _material(
          BlocProvider(
            create: (_) => sl<RecurringTransactionCubit>(),
            child: AddEditRecurringTransactionPage(transaction: transaction),
          ),
          settings,
        );
      case recovery:
        return _material(const RecoveryPage(), settings);
      default:
        return _material(const AuthGatePage(), settings);
    }
  }

  static MaterialPageRoute<dynamic> _material(
      Widget child, RouteSettings settings) {
    return MaterialPageRoute(builder: (_) => child, settings: settings);
  }
}
