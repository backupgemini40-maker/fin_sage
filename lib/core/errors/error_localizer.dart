import 'package:fin_sage/core/errors/app_error_codes.dart';
import 'package:fin_sage/l10n/generated/app_localizations.dart';

String localizeErrorMessage(AppLocalizations l10n, String rawMessage) {
  return switch (rawMessage) {
    AppErrorCodes.unexpectedError => l10n.unexpectedError,
    AppErrorCodes.databaseOpenFailed => l10n.databaseOpenFailed,
    AppErrorCodes.categoryAlreadyExists => l10n.categoryExists,
    AppErrorCodes.categoryInUse => l10n.categoryInUse,
    AppErrorCodes.defaultCategoryArchiveBlocked =>
      l10n.defaultCategoryArchiveBlocked,
    AppErrorCodes.accountAlreadyExists => l10n.accountAlreadyExists,
    AppErrorCodes.accountNotFound => l10n.accountNotFound,
    AppErrorCodes.accountBalanceNotZero => l10n.accountBalanceNotZero,
    AppErrorCodes.defaultAccountArchiveBlocked =>
      l10n.defaultAccountArchiveBlocked,
    AppErrorCodes.backupInvalidFile => l10n.backupInvalidFile,
    AppErrorCodes.backupChecksumMismatch => l10n.backupChecksumMismatch,
    AppErrorCodes.googleAuthHeadersUnavailable => l10n.googleAuthUnavailable,
    AppErrorCodes.googleSignInDeveloperError => l10n.googleSignInDeveloperError,
    AppErrorCodes.noDataToExport => l10n.noDataToExport,
    _ => rawMessage,
  };
}
