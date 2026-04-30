import 'package:fin_sage/core/constants/app_routes.dart';
import 'package:fin_sage/core/di/service_locator.dart';
import 'package:fin_sage/core/utils/extensions.dart';
import 'package:fin_sage/core/widgets/atmospheric_scaffold_body.dart';
import 'package:fin_sage/core/widgets/empty_state_panel.dart';
import 'package:fin_sage/core/widgets/loading_skeleton.dart';
import 'package:fin_sage/data/models/recurring_transaction_model.dart';
import 'package:fin_sage/l10n/generated/app_localizations.dart';
import 'package:fin_sage/logic/recurring_transactions/recurring_transaction_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rrule/rrule.dart';

class RecurringTransactionsPage extends StatelessWidget {
  const RecurringTransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<RecurringTransactionCubit>()..loadRecurringTransactions(),
      child: const RecurringTransactionsView(),
    );
  }
}

class RecurringTransactionsView extends StatelessWidget {
  const RecurringTransactionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final localeTag = Localizations.localeOf(context).toLanguageTag();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.recurringTransactionsTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context),
        icon: const Icon(Icons.add),
        label: Text(l10n.addTransaction),
      ),
      body: SafeArea(
        child: AtmosphericScaffoldBody(
          child:
              BlocBuilder<RecurringTransactionCubit, RecurringTransactionState>(
            builder: (context, state) {
              if (state is RecurringTransactionLoading) {
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: 6,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, __) => const LoadingSkeleton(height: 76),
                );
              }
              if (state is RecurringTransactionError) {
                return Center(child: Text(state.message));
              }
              if (state is RecurringTransactionLoaded) {
                if (state.transactions.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () => context
                        .read<RecurringTransactionCubit>()
                        .loadRecurringTransactions(),
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      children: [
                        const SizedBox(height: 72),
                        EmptyStatePanel(
                          title: l10n.recurringEmptyTitle,
                          subtitle: l10n.recurringEmptySubtitle,
                          icon: Icons.calendar_month_outlined,
                        ),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () => context
                      .read<RecurringTransactionCubit>()
                      .loadRecurringTransactions(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.transactions.length,
                    itemBuilder: (context, index) {
                      final tx = state.transactions[index];
                      final isIncome = tx.type.name == 'income';
                      final amountColor = isIncome
                          ? Colors.green.shade700
                          : Theme.of(context).colorScheme.error;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Card(
                          child: ListTile(
                            leading: Icon(
                              isIncome
                                  ? Icons.arrow_downward_rounded
                                  : Icons.arrow_upward_rounded,
                              color: amountColor,
                            ),
                            title: Text(tx.title),
                            subtitle: Text(
                              '${_frequencyLabel(l10n, tx.recurrenceRule)} • ${DateFormat.yMMMd(localeTag).format(tx.nextOccurrenceDate)}',
                            ),
                            trailing: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 176),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      '${isIncome ? '+' : '-'}${tx.amount.toCurrency(localeTag)}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: amountColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit_outlined),
                                    onPressed: () =>
                                        _openForm(context, existing: tx),
                                    tooltip: l10n.updateActionLabel,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    onPressed: tx.id == null
                                        ? null
                                        : () => _confirmDelete(context, tx.id!),
                                    tooltip: l10n.deleteActionLabel,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Future<void> _openForm(BuildContext context,
      {RecurringTransactionModel? existing}) async {
    final saved = await Navigator.of(context).pushNamed(
      AppRoutes.addEditRecurringTransaction,
      arguments: existing,
    );
    if (saved == true && context.mounted) {
      await context
          .read<RecurringTransactionCubit>()
          .loadRecurringTransactions();
    }
  }

  Future<void> _confirmDelete(BuildContext context, int id) async {
    final l10n = AppLocalizations.of(context);
    final approved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.confirmDeleteTitle),
          content: Text(l10n.confirmDeleteBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(l10n.cancelLabel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(l10n.deleteActionLabel),
            ),
          ],
        );
      },
    );

    if (approved == true && context.mounted) {
      await HapticFeedback.mediumImpact();
      await context
          .read<RecurringTransactionCubit>()
          .deleteRecurringTransaction(id);
    }
  }

  String _frequencyLabel(AppLocalizations l10n, String rule) {
    try {
      final frequency = RecurrenceRule.fromString(rule).frequency;
      switch (frequency) {
        case Frequency.daily:
          return l10n.recurrenceDaily;
        case Frequency.weekly:
          return l10n.recurrenceWeekly;
        case Frequency.monthly:
          return l10n.recurrenceMonthly;
        case Frequency.yearly:
          return l10n.recurrenceYearly;
      }
      return l10n.recurrenceCustom;
    } catch (_) {
      return l10n.recurrenceCustom;
    }
  }
}
