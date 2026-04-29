import 'package:fin_sage/core/constants/app_routes.dart';
import 'package:fin_sage/core/errors/error_boundary.dart';
import 'package:fin_sage/l10n/generated/app_localizations.dart';
import 'package:fin_sage/logic/budgets/budget_cubit.dart';
import 'package:fin_sage/logic/dashboard/dashboard_cubit.dart';
import 'package:fin_sage/logic/settings/settings_cubit.dart';
import 'package:fin_sage/logic/transactions/transaction_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecoveryPage extends StatelessWidget {
  const RecoveryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ErrorBoundary(
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      size: 52,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      l10n.recoveryWelcomeTitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.recoveryWelcomeBody,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      icon: const Icon(Icons.restart_alt),
                      onPressed: () => _startFresh(context),
                      label: Text(l10n.recoveryStartNewAction),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.restore),
                      onPressed: () => _goToRestore(context),
                      label: Text(l10n.recoveryRestoreAction),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _startFresh(BuildContext context) async {
  await HapticFeedback.mediumImpact();
  await context.read<TransactionCubit>().recoverCorruptedDatabase();
  if (!context.mounted) {
    return;
  }
  await context.read<BudgetCubit>().loadBudgets();
  if (!context.mounted) {
    return;
  }
  await context.read<DashboardCubit>().loadOverview();
  if (!context.mounted) {
    return;
  }
  await context.read<SettingsCubit>().loadSettings();
  if (!context.mounted) {
    return;
  }

  Navigator.pushNamedAndRemoveUntil(context, AppRoutes.root, (_) => false);
}

Future<void> _goToRestore(BuildContext context) async {
  await context.read<SettingsCubit>().loadRestorePreview();
  if (!context.mounted) {
    return;
  }
  Navigator.pushNamedAndRemoveUntil(context, AppRoutes.settingsRoute, (_) => false);
}
