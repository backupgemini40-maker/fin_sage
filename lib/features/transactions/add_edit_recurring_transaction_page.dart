import 'package:fin_sage/core/di/service_locator.dart';
import 'package:fin_sage/core/widgets/icon_mapper.dart';
import 'package:fin_sage/data/models/account_model.dart';
import 'package:fin_sage/data/models/category_model.dart';
import 'package:fin_sage/data/models/recurring_transaction_model.dart';
import 'package:fin_sage/data/models/transaction_model.dart';
import 'package:fin_sage/data/repositories/account_repository.dart';
import 'package:fin_sage/data/repositories/transaction_repository.dart';
import 'package:fin_sage/l10n/generated/app_localizations.dart';
import 'package:fin_sage/logic/recurring_transactions/recurring_transaction_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rrule/rrule.dart';

class AddEditRecurringTransactionPage extends StatefulWidget {
  const AddEditRecurringTransactionPage({super.key, this.transaction});

  final RecurringTransactionModel? transaction;

  @override
  State<AddEditRecurringTransactionPage> createState() =>
      _AddEditRecurringTransactionPageState();
}

class _AddEditRecurringTransactionPageState
    extends State<AddEditRecurringTransactionPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _amountController;
  late final TextEditingController _recurrenceRuleController;

  bool _loadingOptions = true;
  String? _optionsError;
  List<CategoryModel> _categories = const [];
  List<AccountModel> _accounts = const [];
  int? _selectedCategoryId;
  int? _selectedAccountId;
  DateTime _selectedDate = DateTime.now();
  TransactionType _selectedType = TransactionType.expense;
  RecurrenceFrequency _selectedFrequency = RecurrenceFrequency.monthly;

  bool get _isEditing => widget.transaction != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.transaction;
    _titleController = TextEditingController(text: existing?.title ?? '');
    _amountController = TextEditingController(
      text: existing == null ? '' : existing.amount.toStringAsFixed(0),
    );
    _recurrenceRuleController = TextEditingController(
      text: existing?.recurrenceRule ?? _ruleForFrequency(_selectedFrequency),
    );
    _selectedDate = existing?.nextOccurrenceDate ?? DateTime.now();
    _selectedType = existing?.type ?? TransactionType.expense;
    _selectedFrequency = _inferFrequency(_recurrenceRuleController.text);

    _loadOptions();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _recurrenceRuleController.dispose();
    super.dispose();
  }

  Future<void> _loadOptions() async {
    try {
      final results = await Future.wait([
        sl<TransactionRepository>().fetchCategories(),
        sl<AccountRepository>().getAccounts(),
      ]);
      if (!mounted) {
        return;
      }
      final categories = results[0] as List<CategoryModel>;
      final accounts = results[1] as List<AccountModel>;
      final existing = widget.transaction;

      setState(() {
        _categories = categories;
        _accounts = accounts;

        if (existing != null &&
            categories.any((category) => category.id == existing.categoryId)) {
          _selectedCategoryId = existing.categoryId;
        } else if (categories.isNotEmpty) {
          _selectedCategoryId = categories.first.id;
        }

        if (existing != null &&
            accounts.any((account) => account.id == existing.accountId)) {
          _selectedAccountId = existing.accountId;
        } else if (accounts.isNotEmpty) {
          _selectedAccountId = accounts.first.id;
        }

        _loadingOptions = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _optionsError = e.toString();
        _loadingOptions = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing
              ? l10n.editRecurringTransaction
              : l10n.addRecurringTransaction,
        ),
      ),
      body: _buildBody(context, l10n),
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations l10n) {
    if (_loadingOptions) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_optionsError != null) {
      return Center(child: Text(_optionsError!));
    }
    if (_categories.isEmpty || _accounts.isEmpty) {
      return Center(
        child: Text(
          l10n.accountAndCategoryRequired,
          textAlign: TextAlign.center,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: l10n.titleLabel),
              validator: (value) => value == null || value.trim().isEmpty
                  ? l10n.requiredField
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(labelText: l10n.amountLabel),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || double.tryParse(value) == null) {
                  return l10n.requiredField;
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<TransactionType>(
              value: _selectedType,
              decoration: InputDecoration(labelText: l10n.transactionTypeLabel),
              items: [
                DropdownMenuItem(
                  value: TransactionType.expense,
                  child: Text(l10n.expenseType),
                ),
                DropdownMenuItem(
                  value: TransactionType.income,
                  child: Text(l10n.incomeType),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedType = value);
                }
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              value: _selectedCategoryId,
              decoration: InputDecoration(labelText: l10n.categoryLabel),
              items: _categories
                  .where((category) => category.id != null)
                  .map(
                    (category) => DropdownMenuItem<int>(
                      value: category.id!,
                      child: Row(
                        children: [
                          Icon(mapStringToIconData(category.icon), size: 18),
                          const SizedBox(width: 8),
                          Flexible(child: Text(category.name)),
                        ],
                      ),
                    ),
                  )
                  .toList(growable: false),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedCategoryId = value);
                }
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              value: _selectedAccountId,
              decoration: InputDecoration(labelText: l10n.accountLabel),
              items: _accounts
                  .where((account) => account.id != null)
                  .map(
                    (account) => DropdownMenuItem<int>(
                      value: account.id!,
                      child: Text(account.name),
                    ),
                  )
                  .toList(growable: false),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedAccountId = value);
                }
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<RecurrenceFrequency>(
              value: _selectedFrequency,
              decoration: InputDecoration(labelText: l10n.recurrenceLabel),
              items: [
                DropdownMenuItem(
                  value: RecurrenceFrequency.daily,
                  child: Text(l10n.recurrenceDaily),
                ),
                DropdownMenuItem(
                  value: RecurrenceFrequency.weekly,
                  child: Text(l10n.recurrenceWeekly),
                ),
                DropdownMenuItem(
                  value: RecurrenceFrequency.monthly,
                  child: Text(l10n.recurrenceMonthly),
                ),
                DropdownMenuItem(
                  value: RecurrenceFrequency.yearly,
                  child: Text(l10n.recurrenceYearly),
                ),
                DropdownMenuItem(
                  value: RecurrenceFrequency.custom,
                  child: Text(l10n.recurrenceCustom),
                ),
              ],
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  _selectedFrequency = value;
                  if (value != RecurrenceFrequency.custom) {
                    _recurrenceRuleController.text = _ruleForFrequency(value);
                  }
                });
              },
            ),
            const SizedBox(height: 12),
            if (_selectedFrequency == RecurrenceFrequency.custom)
              TextFormField(
                controller: _recurrenceRuleController,
                decoration: InputDecoration(
                  labelText: l10n.rruleLabel,
                  hintText: 'FREQ=MONTHLY',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.requiredField;
                  }
                  try {
                    RecurrenceRule.fromString(value.trim());
                  } catch (_) {
                    return l10n.invalidRRule;
                  }
                  return null;
                },
              ),
            if (_selectedFrequency != RecurrenceFrequency.custom)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.recurrenceRuleLabel),
                subtitle: Text(_recurrenceRuleController.text),
              ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.dateLabel),
              subtitle: Text(MaterialLocalizations.of(context)
                  .formatMediumDate(_selectedDate)),
              trailing: const Icon(Icons.calendar_today_outlined),
              onTap: () async {
                final selected = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (selected != null) {
                  setState(() => _selectedDate = selected);
                }
              },
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _save,
              child: Text(l10n.saveLabel),
            ),
          ],
        ),
      ),
    );
  }

  String _ruleForFrequency(RecurrenceFrequency frequency) {
    switch (frequency) {
      case RecurrenceFrequency.daily:
        return RecurrenceRule(frequency: Frequency.daily).toString();
      case RecurrenceFrequency.weekly:
        return RecurrenceRule(frequency: Frequency.weekly).toString();
      case RecurrenceFrequency.monthly:
        return RecurrenceRule(frequency: Frequency.monthly).toString();
      case RecurrenceFrequency.yearly:
        return RecurrenceRule(frequency: Frequency.yearly).toString();
      case RecurrenceFrequency.custom:
        return _recurrenceRuleController.text.trim();
    }
  }

  RecurrenceFrequency _inferFrequency(String rule) {
    try {
      final recurrenceRule = RecurrenceRule.fromString(rule);
      switch (recurrenceRule.frequency) {
        case Frequency.daily:
          return RecurrenceFrequency.daily;
        case Frequency.weekly:
          return RecurrenceFrequency.weekly;
        case Frequency.monthly:
          return RecurrenceFrequency.monthly;
        case Frequency.yearly:
          return RecurrenceFrequency.yearly;
      }
      return RecurrenceFrequency.custom;
    } catch (_) {
      return RecurrenceFrequency.custom;
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final categoryId = _selectedCategoryId;
    final accountId = _selectedAccountId;
    if (categoryId == null || accountId == null) {
      return;
    }

    final rule = _selectedFrequency == RecurrenceFrequency.custom
        ? _recurrenceRuleController.text.trim()
        : _ruleForFrequency(_selectedFrequency);

    final tx = RecurringTransactionModel(
      id: widget.transaction?.id,
      title: _titleController.text.trim(),
      amount: double.parse(_amountController.text.trim()),
      type: _selectedType,
      recurrenceRule: rule,
      nextOccurrenceDate: _selectedDate,
      categoryId: categoryId,
      accountId: accountId,
    );

    await HapticFeedback.mediumImpact();
    if (!mounted) {
      return;
    }

    final cubit = context.read<RecurringTransactionCubit>();
    if (_isEditing) {
      await cubit.updateRecurringTransaction(tx);
    } else {
      await cubit.saveRecurringTransaction(tx);
    }

    if (!mounted) {
      return;
    }
    Navigator.of(context).pop(true);
  }
}

enum RecurrenceFrequency {
  daily,
  weekly,
  monthly,
  yearly,
  custom,
}
