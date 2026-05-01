import 'package:fin_sage/core/errors/error_localizer.dart';
import 'package:fin_sage/core/utils/validators.dart';
import 'package:fin_sage/core/widgets/icon_mapper.dart';
import 'package:fin_sage/core/widgets/loading_skeleton.dart';
import 'package:fin_sage/data/models/category_model.dart';
import 'package:fin_sage/l10n/generated/app_localizations.dart';
import 'package:fin_sage/logic/transactions/transaction_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionCategoriesPage extends StatelessWidget {
  const TransactionCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cubit = context.read<TransactionCubit>();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.manageCategories)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateCategorySheet(context, cubit),
        icon: const Icon(Icons.add),
        label: Text(l10n.addCategory),
      ),
      body: BlocConsumer<TransactionCubit, TransactionState>(
        listenWhen: (previous, current) => previous.error != current.error,
        listener: (context, state) {
          if (state.error == null) {
            return;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizeErrorMessage(l10n, state.error!)),
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
              itemBuilder: (_, __) => const LoadingSkeleton(height: 72),
            );
          }

          final categories = state.categories;

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, index) {
              final category = categories[index];
              final color = _safeParseColor(category.colorHex) ??
                  Theme.of(context).colorScheme.primary;
              final canArchive = category.id != null && category.id != 1;

              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: color.withOpacity(0.16),
                    child: Icon(
                      mapStringToIconData(category.icon),
                      color: color,
                    ),
                  ),
                  title: Text(category.name),
                  subtitle: Text('${category.colorHex} • ${category.icon}'),
                  trailing: canArchive
                      ? IconButton(
                          icon: const Icon(Icons.archive_outlined),
                          tooltip: l10n.archiveActionLabel,
                          onPressed: () async {
                            final approved = await _confirmArchiveCategory(
                                context, category.name);
                            if (!approved ||
                                !context.mounted ||
                                category.id == null) {
                              return;
                            }
                            await HapticFeedback.selectionClick();
                            await cubit.archiveCategory(category.id!);
                          },
                        )
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showCreateCategorySheet(
      BuildContext context, TransactionCubit cubit) async {
    final l10n = AppLocalizations.of(context);
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController();
    final colorCtrl = TextEditingController(text: '#0D3B66');
    var selectedIcon = 'wallet';

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
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: nameCtrl,
                        decoration:
                            InputDecoration(labelText: l10n.categoryNameLabel),
                        validator: (value) => _errorFromCode(
                            l10n, Validators.categoryName(value)),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: colorCtrl,
                        decoration:
                            InputDecoration(labelText: l10n.colorHexLabel),
                        validator: (value) =>
                            _errorFromCode(l10n, Validators.hexColor(value)),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.iconLabel,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final iconName in kSelectableIconNames)
                            ChoiceChip(
                              avatar: Icon(
                                mapStringToIconData(iconName),
                                size: 18,
                              ),
                              label: Text(readableIconName(iconName)),
                              selected: selectedIcon == iconName,
                              onSelected: (_) =>
                                  setState(() => selectedIcon = iconName),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: () async {
                          if (!formKey.currentState!.validate()) {
                            return;
                          }
                          await HapticFeedback.lightImpact();
                          await cubit.createCategory(
                            CategoryModel(
                              id: null,
                              name: nameCtrl.text.trim(),
                              colorHex: colorCtrl.text.trim().isEmpty
                                  ? '#0D3B66'
                                  : colorCtrl.text.trim(),
                              icon: selectedIcon,
                            ),
                          );
                          if (cubit.state.error == null &&
                              sheetContext.mounted) {
                            Navigator.pop(sheetContext);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.categoryCreated)),
                            );
                          }
                        },
                        icon: const Icon(Icons.save_outlined),
                        label: Text(l10n.saveLabel),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<bool> _confirmArchiveCategory(
      BuildContext context, String categoryName) async {
    final l10n = AppLocalizations.of(context);
    final approved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.archiveCategoryTitle),
          content: Text(l10n.archiveCategoryBody(categoryName)),
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
    return approved == true;
  }

  String? _errorFromCode(AppLocalizations l10n, String? code) {
    switch (code) {
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
