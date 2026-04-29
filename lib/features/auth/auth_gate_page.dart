import 'package:fin_sage/core/errors/app_error_codes.dart';
import 'package:fin_sage/features/auth/auth_page.dart';
import 'package:fin_sage/features/dashboard/dashboard_page.dart';
import 'package:fin_sage/features/recovery/recovery_page.dart';
import 'package:fin_sage/core/errors/error_boundary.dart';
import 'package:fin_sage/logic/auth/auth_cubit.dart';
import 'package:fin_sage/logic/budgets/budget_cubit.dart';
import 'package:fin_sage/logic/dashboard/dashboard_cubit.dart';
import 'package:fin_sage/logic/settings/settings_cubit.dart';
import 'package:fin_sage/logic/transactions/transaction_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthGatePage extends StatelessWidget {
  const AuthGatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final hasDatabaseFailure = [
      context.select((DashboardCubit cubit) => cubit.state.error),
      context.select((TransactionCubit cubit) => cubit.state.error),
      context.select((BudgetCubit cubit) => cubit.state.error),
      context.select((SettingsCubit cubit) => cubit.state.error),
    ].contains(AppErrorCodes.databaseOpenFailed);

    return ErrorBoundary(
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          switch (state.status) {
            case AuthStatus.initial:
            case AuthStatus.loading:
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            case AuthStatus.unauthenticated:
            case AuthStatus.error:
              return const AuthPage();
            case AuthStatus.authenticated:
              if (hasDatabaseFailure) {
                return const RecoveryPage();
              }
              return const DashboardPage();
          }
        },
      ),
    );
  }
}
