import 'package:fin_sage/core/errors/error_boundary.dart';
import 'package:fin_sage/core/errors/error_localizer.dart';
import 'package:fin_sage/core/utils/extensions.dart';
import 'package:fin_sage/core/utils/validators.dart';
import 'package:fin_sage/core/constants/app_routes.dart';
import 'package:fin_sage/core/widgets/app_bottom_nav.dart';
import 'package:fin_sage/core/widgets/atmospheric_scaffold_body.dart';
import 'package:fin_sage/core/widgets/empty_state_panel.dart';
import 'package:fin_sage/core/widgets/icon_mapper.dart';
import 'package:fin_sage/core/widgets/loading_skeleton.dart';
import 'package:fin_sage/core/widgets/section_reveal.dart';
import 'package:fin_sage/data/models/account_model.dart';
import 'package:fin_sage/data/models/category_model.dart';
import 'package:fin_sage/data/models/transaction_model.dart';
import 'package:fin_sage/l10n/generated/app_localizations.dart';
import 'package:fin_sage/logic/transactions/transaction_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ErrorBoundary(
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.transactionsTitle),
          actions: [
            IconButton(
              onPressed: () => Navigator.of(context)
                  .pushNamed(AppRoutes.transactionCategories),
              tooltip: l10n.manageCategories,
              icon: const Icon(Icons.category_outlined),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showTransactionForm(context),
          label: Text(l10n.addTransaction),
          icon: const Icon(Icons.add),
        ),
        bottomNavigationBar:
            const AppBottomNav(currentRoute: AppRoutes.transactions),
        body: SafeArea(
          child: AtmosphericScaffoldBody(
            child: BlocConsumer<TransactionCubit, TransactionState>(
              listenWhen: (previous, current) =>
                  previous.error != current.error,
              listener: (context, state) {
                if (state.error == null) {
                  return;
                }
                final message = localizeErrorMessage(l10n, state.error!);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                );
              },
              builder: (context, state) {
                if (state.loading) {
                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: 8,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, __) => const LoadingSkeleton(height: 70),
                  );
                }

                final filteredItems = state.filteredItems;

                if (state.items.isEmpty) {
                  return RefreshIndicator(
                    onRefresh:
                        context.read<TransactionCubit>().loadTransactions,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      children: [
                        const SizedBox(height: 84),
                        EmptyStatePanel(
                          title: l10n.emptyTransactions,
                          subtitle: l10n.addTransaction,
                          icon: Icons.receipt_long_outlined,
                        ),
                      ],
                    ),
                  );
                }

                final locale = Localizations.localeOf(context).toLanguageTag();
                final now = DateTime.now();
                final monthlyItems = state.items
                    .where((tx) =>
                        tx.date.year == now.year && tx.date.month == now.month)
                    .toList(growable: false);
                final incomeTotal = monthlyItems
                    .where((tx) => tx.type == TransactionType.income)
                    .fold<double>(0, (sum, tx) => sum + tx.amount);
                final expenseTotal = monthlyItems
                    .where((tx) => tx.type == TransactionType.expense)
                    .fold<double>(0, (sum, tx) => sum + tx.amount);

                return RefreshIndicator(
                  onRefresh: context.read<TransactionCubit>().loadTransactions,
                  child: TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 360),
                    tween: Tween<double>(begin: 0, end: 1),
                    curve: Curves.easeOut,
                    builder: (context, value, child) {
                      return Opacity(opacity: value, child: child);
                    },
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search),
                            hintText: l10n.searchTransactions,
                          ),
                          onChanged:
                              context.read<TransactionCubit>().setSearchQuery,
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _FilterChip(
                              label: l10n.allType,
                              active: state.filter == TransactionFilter.all,
                              onTap: () => context
                                  .read<TransactionCubit>()
                                  .setFilter(TransactionFilter.all),
                            ),
                            _FilterChip(
                              label: l10n.incomeType,
                              active: state.filter == TransactionFilter.income,
                              onTap: () => context
                                  .read<TransactionCubit>()
                                  .setFilter(TransactionFilter.income),
                            ),
                            _FilterChip(
                              label: l10n.expenseType,
                              active: state.filter == TransactionFilter.expense,
                              onTap: () => context
                                  .read<TransactionCubit>()
                                  .setFilter(TransactionFilter.expense),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SectionReveal(
                          child: Semantics(
                            container: true,
                            label:
                                '${l10n.monthlyIncome}: ${incomeTotal.toCurrency(locale)}. ${l10n.monthlyExpense}: ${expenseTotal.toCurrency(locale)}.',
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(l10n.monthlyIncome),
                                    Text(
                                      incomeTotal.toCurrency(locale),
                                      style: TextStyle(
                                          color: Colors.green.shade700,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(l10n.monthlyExpense),
                                    Text(
                                      expenseTotal.toCurrency(locale),
                                      style: TextStyle(
                                        color:
                                            Theme.of(context).colorScheme.error,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (filteredItems.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: EmptyStatePanel(
                              title: l10n.noMatchingTransactions,
                              subtitle: l10n.searchTransactions,
                              icon: Icons.search_off_outlined,
                            ),
                          )
                        else
                          ...filteredItems.map((tx) {
                            final isIncome = tx.type == TransactionType.income;
                            final amountColor = isIncome
                                ? Colors.green.shade700
                                : Theme.of(context).colorScheme.error;
                            final categoryName = _categoryNameById(
                                state.categories, tx.categoryId);
                            final categoryIcon = _categoryIconById(
                                state.categories, tx.categoryId);
                            final accountName =
                                _accountNameById(state.accounts, tx.accountId);

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Card(
                                child: ListTile(
                                  leading: Icon(
                                    mapStringToIconData(categoryIcon),
                                    color: _categoryColor(
                                            state.categories, tx.categoryId) ??
                                        amountColor,
                                  ),
                                  title: Text(tx.title),
                                  subtitle: Text(
                                    '${DateFormat.yMMMd(locale).format(tx.date)} • $categoryName • $accountName • ${isIncome ? l10n.incomeType : l10n.expenseType}',
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '${isIncome ? '+' : '-'}${tx.amount.toCurrency(locale)}',
                                        style: TextStyle(
                                            color: amountColor,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.edit_outlined),
                                        tooltip: l10n.updateActionLabel,
                                        onPressed: tx.id == null
                                            ? null
                                            : () => _showTransactionForm(
                                                context,
                                                existing: tx),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline),
                                        tooltip: l10n.deleteActionLabel,
                                        onPressed: tx.id == null
                                            ? null
                                            : () =>
                                                _confirmDelete(context, tx.id!),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
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
      await context.read<TransactionCubit>().removeTransaction(id);
    }
  }

  Future<void> _showTransactionForm(BuildContext context,
      {TransactionModel? existing}) async {
    final l10n = AppLocalizations.of(context);
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    final formKey = GlobalKey<FormState>();
    final titleCtrl = TextEditingController(text: existing?.title ?? '');
    final amountCtrl = TextEditingController(
        text: existing == null ? '' : existing.amount.toStringAsFixed(0));
    DateTime selectedDate = existing?.date ?? DateTime.now();
    TransactionType selectedType = existing?.type ?? TransactionType.expense;
    final cubit = context.read<TransactionCubit>();
    final state = context.read<TransactionCubit>().state;
    var categories = List<CategoryModel>.from(state.categories);
    var accounts = List<AccountModel>.from(state.accounts);
    final hasExistingCategory = existing != null &&
        categories.any((category) => category.id == existing.categoryId);
    int selectedCategoryId = hasExistingCategory
        ? existing.categoryId
        : (categories.isNotEmpty
            ? (categories.first.id ?? 1)
            : (existing?.categoryId ?? 1));
    final hasExistingAccount = existing != null &&
        accounts.any((account) => account.id == existing.accountId);
    int selectedAccountId = hasExistingAccount
        ? existing.accountId
        : (accounts.isNotEmpty
            ? (accounts.first.id ?? 1)
            : (existing?.accountId ?? 1));

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 16,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: titleCtrl,
                      decoration: InputDecoration(labelText: l10n.titleLabel),
                      validator: (v) => v == null || v.trim().isEmpty
                          ? l10n.requiredField
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: amountCtrl,
                      decoration: InputDecoration(labelText: l10n.amountLabel),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (v) {
                        final code = Validators.amount(v);
                        return _errorFromCode(l10n, code);
                      },
                    ),
                    const SizedBox(height: 12),
                    if (accounts.isNotEmpty)
                      DropdownButtonFormField<int>(
                        value: selectedAccountId,
                        decoration:
                            InputDecoration(labelText: l10n.accountLabel),
                        items: accounts
                            .map(
                              (account) => DropdownMenuItem<int>(
                                value: account.id ?? 1,
                                child: Text(account.name),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => selectedAccountId = value);
                          }
                        },
                      )
                    else
                      const SizedBox.shrink(), // TODO: Handle no accounts
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(l10n.transactionTypeLabel),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        ChoiceChip(
                          label: Text(l10n.expenseType),
                          selected: selectedType == TransactionType.expense,
                          onSelected: (_) => setState(
                              () => selectedType = TransactionType.expense),
                        ),
                        ChoiceChip(
                          label: Text(l10n.incomeType),
                          selected: selectedType == TransactionType.income,
                          onSelected: (_) => setState(
                              () => selectedType = TransactionType.income),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (categories.isNotEmpty)
                      DropdownButtonFormField<int>(
                        value: selectedCategoryId,
                        decoration:
                            InputDecoration(labelText: l10n.categoryLabel),
                        items: categories
                            .map(
                              (category) => DropdownMenuItem<int>(
                                value: category.id ?? 1,
                                child: Row(
                                  children: [
                                    Icon(
                                      mapStringToIconData(category.icon),
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Flexible(child: Text(category.name)),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => selectedCategoryId = value);
                          }
                        },
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            enabled: false,
                            decoration: InputDecoration(
                                labelText: l10n.categoryLabel, hintText: '#1'),
                          ),
                          const SizedBox(height: 8),
                          OutlinedButton.icon(
                            onPressed: () async {
                              await Navigator.of(sheetContext)
                                  .pushNamed(AppRoutes.transactionCategories);
                              if (!sheetContext.mounted) {
                                return;
                              }
                              final updatedCategories =
                                  List<CategoryModel>.from(
                                      cubit.state.categories);
                              if (updatedCategories.isEmpty) {
                                return;
                              }
                              setState(() {
                                categories = updatedCategories;
                                final stillExists = categories.any((category) =>
                                    category.id == selectedCategoryId);
                                if (!stillExists) {
                                  selectedCategoryId =
                                      categories.first.id ?? selectedCategoryId;
                                }
                              });
                            },
                            icon: const Icon(Icons.add),
                            label: Text(l10n.manageCategories),
                          ),
                        ],
                      ),
                    const SizedBox(height: 12),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                          DateFormat.yMMMd(localeTag).format(selectedDate)),
                      subtitle: Text(l10n.dateLabel),
                      trailing: const Icon(Icons.calendar_today_outlined),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: sheetContext,
                          initialDate: selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          setState(() => selectedDate = date);
                        }
                      },
                    ),
                    Builder(
                      builder: (_) {
                        final code = Validators.requiredDate(selectedDate);
                        final error = _errorFromCode(l10n, code);
                        if (error == null) {
                          return const SizedBox.shrink();
                        }
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(error,
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.error)),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () async {
                        if (!formKey.currentState!.validate()) {
                          return;
                        }

                        final dateError = Validators.requiredDate(selectedDate);
                        if (dateError != null) {
                          return;
                        }

                        final parsedAmount = double.tryParse(
                            amountCtrl.text.replaceAll(',', '.'));
                        if (parsedAmount == null) {
                          return;
                        }

                        final model = TransactionModel(
                          id: existing?.id,
                          title: titleCtrl.text.trim(),
                          amount: parsedAmount,
                          date: selectedDate,
                          categoryId: selectedCategoryId,
                          accountId: selectedAccountId,
                          type: selectedType,
                        );
                        await HapticFeedback.lightImpact();

                        if (existing == null) {
                          await cubit.createTransaction(model);
                        } else {
                          await cubit.updateTransaction(model);
                        }
                        if (!sheetContext.mounted) {
                          return;
                        }
                        if (cubit.state.error == null) {
                          Navigator.pop(sheetContext);
                        }
                      },
                      child: Text(existing == null
                          ? l10n.saveLabel
                          : l10n.updateActionLabel),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String? _errorFromCode(AppLocalizations l10n, String? code) {
    switch (code) {
      case 'amountRequired':
        return l10n.amountRequired;
      case 'amountInvalid':
        return l10n.amountInvalid;
      case 'amountMustBePositive':
        return l10n.amountMustBePositive;
      case 'amountTooLarge':
        return l10n.amountTooLarge;
      case 'dateRequired':
        return l10n.dateRequired;
      case 'dateFutureNotAllowed':
        return l10n.dateFutureNotAllowed;
      case 'categoryNameRequired':
        return l10n.categoryNameRequired;
      case 'categoryNameTooLong':
        return l10n.categoryNameTooLong;
      case 'invalidColorHex':
        return l10n.invalidColorHex;
      default:
        return null;
    }
  }

  String _categoryNameById(List<CategoryModel> categories, int id) {
    for (final category in categories) {
      if (category.id == id) {
        return category.name;
      }
    }
    return '#$id';
  }

  String _categoryIconById(List<CategoryModel> categories, int id) {
    for (final category in categories) {
      if (category.id == id) {
        return category.icon;
      }
    }
    return 'receipt_long';
  }

  String _accountNameById(List<AccountModel> accounts, int id) {
    for (final account in accounts) {
      if (account.id == id) {
        return account.name;
      }
    }
    return '#$id';
  }

  Color? _categoryColor(List<CategoryModel> categories, int id) {
    for (final category in categories) {
      if (category.id == id) {
        return _safeParseColor(category.colorHex);
      }
    }
    return null;
  }

  Color? _safeParseColor(String hex) {
    final normalized = hex.trim().replaceFirst('#', '');
    if (normalized.length != 6) {
      return null;
    }
    final value = int.tryParse(normalized, radix: 16);
    if (value == null) {
      return null;
    }
    return Color(0xFF000000 | value);
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: active,
      onSelected: (_) => onTap(),
    );
  }
}
