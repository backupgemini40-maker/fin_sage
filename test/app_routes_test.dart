import 'package:fin_sage/core/constants/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('onGenerateRoute preserves route settings name for known routes', () {
    final routes = <String>[
      AppRoutes.root,
      AppRoutes.auth,
      AppRoutes.dashboard,
      AppRoutes.transactions,
      AppRoutes.transactionCategories,
      AppRoutes.budgets,
      AppRoutes.reports,
      AppRoutes.settingsRoute,
    ];

    for (final routeName in routes) {
      final route = AppRoutes.onGenerateRoute(RouteSettings(name: routeName));
      expect(route.settings.name, routeName);
    }
  });

  test('unknown route falls back to auth gate while keeping requested name',
      () {
    const unknown = '/unknown';
    final route = AppRoutes.onGenerateRoute(const RouteSettings(name: unknown));
    expect(route.settings.name, unknown);
    expect(route, isA<MaterialPageRoute<dynamic>>());
  });
}
