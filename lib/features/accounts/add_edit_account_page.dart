import 'package:fin_sage/core/errors/error_localizer.dart';
import 'package:fin_sage/core/utils/validators.dart';
import 'package:fin_sage/core/widgets/atmospheric_scaffold_body.dart';
import 'package:fin_sage/data/models/account_model.dart';
import 'package:fin_sage/l10n/generated/app_localizations.dart';
import 'package:fin_sage/logic/accounts/account_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddEditAccountPage extends StatefulWidget {
  const AddEditAccountPage({super.key, this.account});

  final AccountModel? account;

  @override
  State<AddEditAccountPage> createState() => _AddEditAccountPageState();
}

class _AddEditAccountPageState extends State<AddEditAccountPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _balanceController;
  late String _selectedType;
  late String _selectedColor;
  late String _selectedIcon;

  bool get _isEditing => widget.account != null;

  static const _colorOptions = [
    '#0D3B66',
    '#4F8FC0',
    '#5CA4A9',
    '#F2A65A',
    '#8A4FFF',
    '#2E7D32',
  ];

  static const _iconOptions = [
    'account_balance_wallet',
    'account_balance',
    'wallet',
    'savings',
    'credit_card',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.account?.name);
    _balanceController =
        TextEditingController(text: widget.account?.balance.toString() ?? '0');
    _selectedType = widget.account?.type ?? 'Cash';
    _selectedColor = widget.account?.colorHex ?? _colorOptions.first;
    _selectedIcon = widget.account?.icon ?? _iconOptions.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocListener<AccountCubit, AccountState>(
      listener: (context, state) {
        final error = state is AccountError ? state.message : null;
        if (error == null) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizeErrorMessage(l10n, error)),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEditing ? l10n.editAccount : l10n.addAccount),
        ),
        body: SafeArea(
          child: AtmosphericScaffoldBody(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration:
                          InputDecoration(labelText: l10n.accountNameLabel),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? l10n.requiredField
                              : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _balanceController,
                      decoration: InputDecoration(
                        labelText: _isEditing
                            ? l10n.currentBalanceLabel
                            : l10n.initialBalanceLabel,
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        final code = Validators.amount(value);
                        if (code == 'amountMustBePositive') {
                          return null;
                        }
                        return _errorFromCode(l10n, code);
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.accountTypeLabel,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final entry in _localizedTypes(l10n).entries)
                          ChoiceChip(
                            label: Text(entry.value),
                            selected: _selectedType == entry.key,
                            onSelected: (_) =>
                                setState(() => _selectedType = entry.key),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.accountColorLabel,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        for (final colorHex in _colorOptions)
                          _ColorSwatch(
                            colorHex: colorHex,
                            selected: _selectedColor == colorHex,
                            onTap: () =>
                                setState(() => _selectedColor = colorHex),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.iconLabel,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final icon in _iconOptions)
                          ChoiceChip(
                            avatar: Icon(_iconForName(icon), size: 18),
                            label: Text(_iconLabel(icon)),
                            selected: _selectedIcon == icon,
                            onSelected: (_) =>
                                setState(() => _selectedIcon = icon),
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: _save,
                      icon: const Icon(Icons.save_outlined),
                      label: Text(l10n.saveLabel),
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

  Map<String, String> _localizedTypes(AppLocalizations l10n) {
    return {
      'Cash': l10n.accountTypeCash,
      'Bank': l10n.accountTypeBank,
      'Wallet': l10n.accountTypeWallet,
      'Savings': l10n.accountTypeSavings,
      'Credit': l10n.accountTypeCredit,
    };
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final balance = double.parse(
      _balanceController.text.trim().replaceAll(',', '.'),
    );
    final account = AccountModel(
      id: widget.account?.id,
      name: _nameController.text.trim(),
      type: _selectedType,
      balance: balance,
      colorHex: _selectedColor,
      icon: _selectedIcon,
    );

    await HapticFeedback.mediumImpact();
    if (!mounted) {
      return;
    }
    final cubit = context.read<AccountCubit>();
    final saved = _isEditing
        ? await cubit.updateAccount(account)
        : await cubit.saveAccount(account);
    if (saved && mounted) {
      Navigator.of(context).pop(true);
    }
  }

  String? _errorFromCode(AppLocalizations l10n, String? code) {
    switch (code) {
      case 'amountRequired':
        return l10n.amountRequired;
      case 'amountInvalid':
        return l10n.amountInvalid;
      case 'amountTooLarge':
        return l10n.amountTooLarge;
      default:
        return null;
    }
  }

  IconData _iconForName(String icon) {
    return switch (icon) {
      'account_balance' => Icons.account_balance_outlined,
      'savings' => Icons.savings_outlined,
      'credit_card' => Icons.credit_card_outlined,
      'wallet' => Icons.wallet_outlined,
      _ => Icons.account_balance_wallet_outlined,
    };
  }

  String _iconLabel(String icon) {
    return icon.replaceAll('_', ' ');
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({
    required this.colorHex,
    required this.selected,
    required this.onTap,
  });

  final String colorHex;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _parseColor(colorHex);

    return Semantics(
      button: true,
      selected: selected,
      label: colorHex,
      child: InkResponse(
        onTap: onTap,
        radius: 26,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected
                  ? Theme.of(context).colorScheme.onSurface
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: selected
              ? const Icon(Icons.check, color: Colors.white, size: 20)
              : null,
        ),
      ),
    );
  }

  Color _parseColor(String hex) {
    final normalized = hex.replaceFirst('#', '');
    return Color(0xFF000000 | int.parse(normalized, radix: 16));
  }
}
