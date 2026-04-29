import 'package:fl_chart/fl_chart.dart';
import 'package:fin_sage/core/constants/app_routes.dart';
import 'package:fin_sage/core/constants/icons/budget_icon.dart';
import 'package:fin_sage/core/constants/icons/report_icon.dart';
import 'package:fin_sage/core/constants/icons/settings_icon.dart';
import 'package:fin_sage/core/constants/icons/transaction_icon.dart';
import 'package:fin_sage/core/errors/error_boundary.dart';
import 'package:fin_sage/core/utils/extensions.dart';
import 'package:fin_sage/core/widgets/animated_balance_chart.dart';
import 'package:fin_sage/core/widgets/app_bottom_nav.dart';
import 'package:fin_sage/core/widgets/loading_skeleton.dart';
import 'package:fin_sage/core/widgets/premium_card.dart';
import 'package:fin_sage/data/models/transaction_model.dart';
import 'package:fin_sage/l10n/generated/app_localizations.dart';
import 'package:fin_sage/logic/dashboard/dashboard_cubit.dart';
import 'package:fin_sage/logic/transactions/transaction_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ErrorBoundary(
      child: BlocListener<TransactionCubit, TransactionState>(
        listenWhen: (previous, current) => previous.items != current.items,
        listener: (context, _) => context.read<DashboardCubit>().loadOverview(),
        child: Scaffold(
          appBar: AppBar(title: Text(l10n.dashboardTitle)),
          bottomNavigationBar: const AppBottomNav(currentRoute: AppRoutes.dashboard),
          body: SafeArea(
            child: BlocBuilder<DashboardCubit, DashboardState>(
              builder: (context, state) {
                if (state.loading) {
                  return Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const LoadingSkeleton(height: 180),
                        const SizedBox(height: 16),
                        Row(
                          children: const [
                            Expanded(child: LoadingSkeleton(height: 86)),
                            SizedBox(width: 12),
                            Expanded(child: LoadingSkeleton(height: 86)),
                          ],
                        ),
                        SizedBox(height: 16),
                        const LoadingSkeleton(height: 220),
                        const SizedBox(height: 16),
                        const LoadingSkeleton(height: 54),
                        const SizedBox(height: 10),
                        const LoadingSkeleton(height: 54),
                        const SizedBox(height: 10),
                        const LoadingSkeleton(height: 54),
                      ],
                    ),
                  );
                }

                final locale = Localizations.localeOf(context).toLanguageTag();
                final trendSpots = <FlSpot>[
                  for (var i = 0; i < state.balanceTrend.length; i++)
                    FlSpot(i.toDouble(), state.balanceTrend[i].balance),
                ];
                final trendDates = <DateTime>[
                  for (final point in state.balanceTrend) point.date,
                ];

                return RefreshIndicator(
                  onRefresh: context.read<DashboardCubit>().loadOverview,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      PremiumCard(
                        child: Semantics(
                          container: true,
                          label:
                              '${l10n.totalBalance}: ${state.balance.toCurrency(locale)}. ${l10n.monthlyIncome}: ${state.income.toCurrency(locale)}. ${l10n.monthlyExpense}: ${state.expense.toCurrency(locale)}.',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l10n.totalBalance),
                              const SizedBox(height: 8),
                              Text(
                                state.balance.toCurrency(locale),
                                textScaler: MediaQuery.textScalerOf(context),
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white),
                              ),
                              const SizedBox(height: 16),
                              Text('${l10n.monthlyIncome}: ${state.income.toCurrency(locale)}'),
                              Text('${l10n.monthlyExpense}: ${state.expense.toCurrency(locale)}'),
                              const SizedBox(height: 8),
                              Text('${l10n.monthlyTransactions}: ${state.monthlyTransactionCount}'),
                            ],
                          ),
                        ),
                      ),
                      if (state.error != null) ...[
                        const SizedBox(height: 12),
                        Card(
                          color: Theme.of(context).colorScheme.errorContainer,
                          child: ListTile(
                            title: Text(state.error!),
                            trailing: IconButton(
                              icon: const Icon(Icons.refresh),
                              tooltip: l10n.refreshLabel,
                              onPressed: () => context.read<DashboardCubit>().loadOverview(),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      Semantics(
                        container: true,
                        label: l10n.balanceTrendChartLabel,
                        child: AnimatedBalanceChart(
                          spots: trendSpots,
                          labels: trendDates,
                          locale: locale,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(l10n.recentTransactions, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 10),
                      if (state.recentTransactions.isEmpty)
                        Text(l10n.emptyTransactions)
                      else
                        ...state.recentTransactions.map(
                          (tx) => _RecentTransactionTile(
                            tx: tx,
                            locale: locale,
                            incomeLabel: l10n.incomeType,
                            expenseLabel: l10n.expenseType,
                          ),
                        ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _RouteChip(
                            label: l10n.transactionsTitle,
                            route: AppRoutes.transactions,
                            svg: kTransactionIconSvg,
                          ),
                          _RouteChip(label: l10n.budgetsTitle, route: AppRoutes.budgets, svg: kBudgetIconSvg),
                          _RouteChip(label: l10n.reportsTitle, route: AppRoutes.reports, svg: kReportIconSvg),
                          _RouteChip(
                            label: l10n.settingsTitle,
                            route: AppRoutes.settingsRoute,
                            svg: kSettingsIconSvg,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _RecentTransactionTile extends StatelessWidget {
  const _RecentTransactionTile({
    required this.tx,
    required this.locale,
    required this.incomeLabel,
    required this.expenseLabel,
  });

  final TransactionModel tx;
  final String locale;
  final String incomeLabel;
  final String expenseLabel;

  @override
  Widget build(BuildContext context) {
    final isIncome = tx.type == TransactionType.income;
    final amountColor = isIncome ? Colors.green.shade700 : Theme.of(context).colorScheme.error;
    return Card(
      child: ListTile(
        leading: Icon(isIncome ? Icons.south_west : Icons.north_east, color: amountColor),
        title: Text(tx.title),
        subtitle: Text('${DateFormat.yMMMd(locale).format(tx.date)} • ${isIncome ? incomeLabel : expenseLabel}'),
        trailing: Text(
          '${isIncome ? '+' : '-'}${tx.amount.toCurrency(locale)}',
          style: TextStyle(fontWeight: FontWeight.w700, color: amountColor),
        ),
      ),
    );
  }
}

class _RouteChip extends StatelessWidget {
  const _RouteChip({required this.label, required this.route, required this.svg});

  final String label;
  final String route;
  final String svg;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: SvgPicture.string(svg, width: 18, height: 18),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      onPressed: () => Navigator.pushNamed(context, route),
    );
  }
}
