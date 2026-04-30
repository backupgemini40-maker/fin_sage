import 'package:fin_sage/core/constants/app_routes.dart';
import 'package:fin_sage/core/di/service_locator.dart';
import 'package:fin_sage/core/errors/error_localizer.dart';
import 'package:fin_sage/core/utils/extensions.dart';
import 'package:fin_sage/core/widgets/app_bottom_nav.dart';
import 'package:fin_sage/core/widgets/atmospheric_scaffold_body.dart';
import 'package:fin_sage/core/widgets/empty_state_panel.dart';
import 'package:fin_sage/core/widgets/icon_mapper.dart';
import 'package:fin_sage/core/widgets/loading_skeleton.dart';
import 'package:fin_sage/core/widgets/premium_card.dart';
import 'package:fin_sage/core/widgets/section_reveal.dart';
import 'package:fin_sage/data/models/account_model.dart';
import 'package:fin_sage/l10n/generated/app_localizations.dart';
import 'package:fin_sage/logic/accounts/account_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountsPage extends StatelessWidget {
  const AccountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AccountCubit>()..loadAccounts(),
      child: const AccountsView(),
    );
  }
}

class AccountsView extends StatelessWidget {
  const AccountsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.accountsTitle),
      ),
      bottomNavigationBar: const AppBottomNav(currentRoute: AppRoutes.accounts),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context),
        icon: const Icon(Icons.add),
        label: Text(l10n.addAccount),
      ),
      body: SafeArea(
        child: AtmosphericScaffoldBody(
          child: BlocConsumer<AccountCubit, AccountState>(
            listenWhen: (previous, current) {
              return current is AccountLoaded && current.error != null ||
                  current is AccountError;
            },
            listener: (context, state) {
              final error = switch (state) {
                AccountLoaded(error: final message) => message,
                AccountError(message: final message) => message,
                _ => null,
              };
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
            builder: (context, state) {
              if (state is AccountLoading) {
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: 6,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, index) =>
                      LoadingSkeleton(height: index == 0 ? 132 : 76),
                );
              }
              if (state is AccountError) {
                return Center(
                    child: Text(localizeErrorMessage(l10n, state.message)));
              }
              if (state is AccountLoaded) {
                return _AccountsContent(accounts: state.accounts);
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Future<void> _openForm(BuildContext context, {AccountModel? account}) async {
    final saved = await Navigator.of(context).pushNamed(
      AppRoutes.addEditAccount,
      arguments: account,
    );
    if (saved == true && context.mounted) {
      await context.read<AccountCubit>().loadAccounts();
    }
  }
}

class _AccountsContent extends StatelessWidget {
  const _AccountsContent({required this.accounts});

  final List<AccountModel> accounts;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final totalBalance =
        accounts.fold<double>(0, (sum, account) => sum + account.balance);

    return RefreshIndicator(
      onRefresh: context.read<AccountCubit>().loadAccounts,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          SectionReveal(
            child: PremiumCard(
              child: Semantics(
                container: true,
                label:
                    '${l10n.totalBalance}: ${totalBalance.toCurrency(locale)}. ${l10n.totalAccounts(accounts.length)}.',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.totalBalance),
                    const SizedBox(height: 8),
                    Text(
                      totalBalance.toCurrency(locale),
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(l10n.totalAccounts(accounts.length)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (accounts.isEmpty)
            EmptyStatePanel(
              title: l10n.emptyAccounts,
              subtitle: l10n.emptyAccountsSubtitle,
              icon: Icons.account_balance_wallet_outlined,
            )
          else
            ...accounts.map(
              (account) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _AccountTile(account: account),
              ),
            ),
        ],
      ),
    );
  }
}

class _AccountTile extends StatelessWidget {
  const _AccountTile({required this.account});

  final AccountModel account;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final color = _safeParseColor(account.colorHex) ??
        Theme.of(context).colorScheme.primary;
    final balanceColor = account.balance >= 0
        ? Colors.green.shade700
        : Theme.of(context).colorScheme.error;

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.16),
          foregroundColor: color,
          child: Icon(mapStringToIconData(account.icon)),
        ),
        title: Text(account.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(account.type),
        trailing: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 172),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  account.balance.toCurrency(locale),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: balanceColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: l10n.updateActionLabel,
                onPressed: () => _openForm(context, account: account),
              ),
              IconButton(
                icon: const Icon(Icons.archive_outlined),
                tooltip: l10n.archiveActionLabel,
                onPressed: account.id == null
                    ? null
                    : () => _confirmArchive(context, account),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openForm(BuildContext context, {AccountModel? account}) async {
    final saved = await Navigator.of(context).pushNamed(
      AppRoutes.addEditAccount,
      arguments: account,
    );
    if (saved == true && context.mounted) {
      await context.read<AccountCubit>().loadAccounts();
    }
  }

  Future<void> _confirmArchive(
    BuildContext context,
    AccountModel account,
  ) async {
    final l10n = AppLocalizations.of(context);
    final approved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.archiveAccountTitle),
          content: Text(l10n.archiveAccountBody(account.name)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(l10n.cancelLabel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(l10n.archiveActionLabel),
            ),
          ],
        );
      },
    );

    if (approved == true && context.mounted && account.id != null) {
      await HapticFeedback.mediumImpact();
      final archived =
          await context.read<AccountCubit>().archiveAccount(account.id!);
      if (archived && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.accountArchived)),
        );
      }
    }
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
