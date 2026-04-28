import 'package:fin_sage/features/auth/auth_page.dart';
import 'package:fin_sage/features/auth/auth_gate_page.dart';
import 'package:fin_sage/features/budgets/budgets_page.dart';
import 'package:fin_sage/features/dashboard/dashboard_page.dart';
import 'package:fin_sage/features/reports/reports_page.dart';
import 'package:fin_sage/features/settings/settings_page.dart';
import 'package:fin_sage/features/transactions/transactions_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String root = '/';
  static const String auth = '/auth';
  static const String dashboard = '/dashboard';
  static const String transactions = '/transactions';
  static const String budgets = '/budgets';
  static const String reports = '/reports';
  static const String settingsRoute = '/settings';

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
      case budgets:
        return _material(const BudgetsPage(), settings);
      case reports:
        return _material(const ReportsPage(), settings);
      case settingsRoute:
        return _material(const SettingsPage(), settings);
      default:
        return _material(const AuthGatePage(), settings);
    }
  }

  static MaterialPageRoute<dynamic> _material(Widget child, RouteSettings settings) {
    return MaterialPageRoute(builder: (_) => child, settings: settings);
  }
}
