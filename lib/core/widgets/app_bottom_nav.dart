import 'package:fin_sage/core/constants/app_routes.dart';
import 'package:fin_sage/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, required this.currentRoute});

  final String currentRoute;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final selectedIndex = _routeToIndex(currentRoute);

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor.withOpacity(0.14),
            width: 1,
          ),
        ),
      ),
      child: NavigationBar(
        height: MediaQuery.sizeOf(context).width < 390 ? 66 : 72,
        labelBehavior: MediaQuery.sizeOf(context).width < 390
            ? NavigationDestinationLabelBehavior.onlyShowSelected
            : NavigationDestinationLabelBehavior.alwaysShow,
        selectedIndex: selectedIndex,
        destinations: [
          NavigationDestination(
              icon: const Icon(Icons.dashboard_outlined),
              label: l10n.dashboardTitle),
          NavigationDestination(
              icon: const Icon(Icons.receipt_long_outlined),
              label: l10n.transactionsTitle),
          NavigationDestination(
              icon: const Icon(Icons.account_balance_wallet_outlined),
              label: l10n.accountsTitle),
          NavigationDestination(
              icon: const Icon(Icons.pie_chart_outline),
              label: l10n.budgetsTitle),
          NavigationDestination(
              icon: const Icon(Icons.insert_chart_outlined),
              label: l10n.reportsTitle),
          NavigationDestination(
              icon: const Icon(Icons.settings_outlined),
              label: l10n.settingsTitle),
        ],
        onDestinationSelected: (index) async {
          final targetRoute = _indexToRoute(index);
          if (targetRoute == currentRoute) {
            return;
          }
          await HapticFeedback.selectionClick();
          if (!context.mounted) {
            return;
          }
          Navigator.of(context).pushNamedAndRemoveUntil(
            targetRoute,
            (route) => route.settings.name == AppRoutes.root,
          );
        },
      ),
    );
  }

  int _routeToIndex(String route) {
    switch (route) {
      case AppRoutes.dashboard:
        return 0;
      case AppRoutes.transactions:
        return 1;
      case AppRoutes.accounts:
        return 2;
      case AppRoutes.budgets:
        return 3;
      case AppRoutes.reports:
        return 4;
      case AppRoutes.settingsRoute:
        return 5;
      default:
        return 0;
    }
  }

  String _indexToRoute(int index) {
    switch (index) {
      case 0:
        return AppRoutes.dashboard;
      case 1:
        return AppRoutes.transactions;
      case 2:
        return AppRoutes.accounts;
      case 3:
        return AppRoutes.budgets;
      case 4:
        return AppRoutes.reports;
      case 5:
        return AppRoutes.settingsRoute;
      default:
        return AppRoutes.dashboard;
    }
  }
}
