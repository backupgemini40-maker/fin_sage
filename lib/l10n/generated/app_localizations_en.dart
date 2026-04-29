// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'FinSage';

  @override
  String get unexpectedError => 'Unexpected error';

  @override
  String get databaseOpenFailed =>
      'Unable to open local encrypted data. This can happen after reinstall. Restore from backup or reset local data.';

  @override
  String get recoveryWelcomeTitle => 'Welcome back';

  @override
  String get recoveryWelcomeBody =>
      'We detected local encrypted data from a previous install. Choose to start fresh or restore from backup.';

  @override
  String get recoveryStartNewAction => 'Start New';

  @override
  String get recoveryRestoreAction => 'Restore from Backup';

  @override
  String get signInGoogle => 'Continue with Google';

  @override
  String get googleSignInConfigMissing =>
      'GOOGLE_SERVER_CLIENT_ID is not set. Define it in dart-define for Google Drive backup auth.';

  @override
  String get googleAuthUnavailable =>
      'Google authentication is unavailable. Please sign in again and retry.';

  @override
  String get googleSignInDeveloperError =>
      'Google Sign-In configuration is invalid (OAuth/SHA-1 mismatch). Verify Firebase and Google Cloud credentials.';

  @override
  String get googleSignInTroubleshootTitle => 'Google Sign-In setup details';

  @override
  String get googleSignInTroubleshootHint =>
      'Use the Android package and keystore SHA-1/SHA-256 values below to match Firebase and Google Cloud OAuth credentials.';

  @override
  String get androidApplicationIdLabel => 'Android applicationId';

  @override
  String get serverClientIdConfiguredLabel =>
      'GOOGLE_SERVER_CLIENT_ID configured';

  @override
  String get clientIdConfiguredLabel => 'GOOGLE_CLIENT_ID configured';

  @override
  String get configuredYes => 'Yes';

  @override
  String get configuredNo => 'No';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get totalBalance => 'Total Balance';

  @override
  String get monthlyIncome => 'Monthly Income';

  @override
  String get monthlyExpense => 'Monthly Expense';

  @override
  String get monthlyTransactions => 'Monthly Transactions';

  @override
  String get balanceTrendChartLabel => 'Balance trend chart';

  @override
  String get recentTransactions => 'Recent Transactions';

  @override
  String get transactionsTitle => 'Transactions';

  @override
  String get budgetsTitle => 'Budgets';

  @override
  String get reportsTitle => 'Reports';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get operationInProgress => 'Processing request...';

  @override
  String get appInfoTitle => 'App Info';

  @override
  String get appVersionLabel => 'Version';

  @override
  String get refreshLabel => 'Refresh';

  @override
  String get addTransaction => 'Add Transaction';

  @override
  String get emptyTransactions => 'No transactions yet';

  @override
  String get searchTransactions => 'Search transactions';

  @override
  String get noMatchingTransactions => 'No matching transactions';

  @override
  String get titleLabel => 'Title';

  @override
  String get amountLabel => 'Amount';

  @override
  String get dateLabel => 'Date';

  @override
  String get allType => 'All';

  @override
  String get transactionTypeLabel => 'Transaction Type';

  @override
  String get incomeType => 'Income';

  @override
  String get expenseType => 'Expense';

  @override
  String get saveLabel => 'Save';

  @override
  String get requiredField => 'This field is required';

  @override
  String get amountRequired => 'Amount is required';

  @override
  String get amountInvalid => 'Enter a valid amount';

  @override
  String get amountMustBePositive => 'Amount must be positive';

  @override
  String get amountTooLarge => 'Amount is too large';

  @override
  String get dateRequired => 'Date is required';

  @override
  String get dateFutureNotAllowed => 'Future date is not allowed';

  @override
  String get noBudgetYet => 'No budget configured';

  @override
  String get categoryLabel => 'Category';

  @override
  String get usedLabel => 'Used';

  @override
  String get limitLabel => 'Limit';

  @override
  String get exportPdf => 'Export PDF';

  @override
  String get exportCsv => 'Export CSV';

  @override
  String get noDataToExport => 'No data to export';

  @override
  String csvSaved(Object path) {
    return 'CSV saved: $path';
  }

  @override
  String selectedMonthLabel(Object month) {
    return 'Month: $month';
  }

  @override
  String monthlyReportTitle(Object month) {
    return 'FinSage Report - $month';
  }

  @override
  String get reportPdfDefaultTitle => 'FinSage Financial Report';

  @override
  String get reportPdfTransactionsLabel => 'Transactions';

  @override
  String get reportPdfIncomeLabel => 'Income';

  @override
  String get reportPdfExpenseLabel => 'Expense';

  @override
  String get reportPdfNetBalanceLabel => 'Net Balance';

  @override
  String get reportCsvHeaderId => 'id';

  @override
  String get reportCsvHeaderTitle => 'title';

  @override
  String get reportCsvHeaderAmount => 'amount';

  @override
  String get reportCsvHeaderType => 'type';

  @override
  String get reportCsvHeaderDate => 'date';

  @override
  String get reportCsvHeaderCategoryId => 'category_id';

  @override
  String transactionCount(Object count) {
    return '$count transactions';
  }

  @override
  String get netBalance => 'Net Balance';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get budgetNotificationsLabel => 'Budget Notifications';

  @override
  String get languageLabel => 'Language';

  @override
  String get systemDefault => 'System Default';

  @override
  String get englishLanguage => 'English';

  @override
  String get indonesianLanguage => 'Indonesian';

  @override
  String get backupNow => 'Backup Now';

  @override
  String lastBackupLabel(Object value) {
    return 'Last backup: $value';
  }

  @override
  String get noBackupHistory => 'No backup history yet';

  @override
  String get restorePreview => 'Restore Preview';

  @override
  String get noBackupFiles => 'No backup files found';

  @override
  String get backupCompleted => 'Backup completed successfully';

  @override
  String get autoBackupValidationScheduled =>
      'Auto-backup validation has been scheduled';

  @override
  String get validateAutoBackupLabel => 'Validate Auto Backup';

  @override
  String get autoBackupStatusTitle => 'Auto Backup Status';

  @override
  String get autoBackupNeverRun => 'Last attempt: never';

  @override
  String get autoBackupNoSuccessYet => 'Last success: not yet';

  @override
  String autoBackupLastAttempt(Object value) {
    return 'Last attempt: $value';
  }

  @override
  String autoBackupLastSuccess(Object value) {
    return 'Last success: $value';
  }

  @override
  String autoBackupLastError(Object value) {
    return 'Last error: $value';
  }

  @override
  String get restorePreviewLoaded => 'Restore preview loaded';

  @override
  String get restoreCompleted => 'Restore completed successfully';

  @override
  String get restoreConfirmTitle => 'Confirm Restore';

  @override
  String get restoreConfirmBody =>
      'Restoring backup will overwrite local data. Continue?';

  @override
  String get backupInvalidFile => 'Backup file is invalid or corrupted';

  @override
  String get backupChecksumMismatch =>
      'Backup integrity check failed (checksum mismatch)';

  @override
  String get signOutLabel => 'Sign Out';

  @override
  String get signOutConfirmBody =>
      'You will be returned to login screen. Continue?';

  @override
  String get resetLocalDataLabel => 'Reset Local Data';

  @override
  String get resetLocalDataConfirmBody =>
      'This will remove local transactions, budgets, and custom categories. Continue?';

  @override
  String get resetActionLabel => 'Reset';

  @override
  String get localDataResetCompleted => 'Local data has been reset';

  @override
  String get manageCategories => 'Manage categories';

  @override
  String get addCategory => 'Add Category';

  @override
  String get categoryNameLabel => 'Category Name';

  @override
  String get colorHexLabel => 'Color (Hex)';

  @override
  String get iconLabel => 'Icon Name';

  @override
  String get categoryCreated => 'Category created';

  @override
  String get categoryExists => 'Category already exists';

  @override
  String get categoryInUse => 'Category is still used by transactions';

  @override
  String get defaultCategoryArchiveBlocked =>
      'Default category cannot be archived';

  @override
  String get archiveCategoryTitle => 'Archive Category';

  @override
  String archiveCategoryBody(Object name) {
    return 'Archive category \"$name\"?';
  }

  @override
  String get archiveActionLabel => 'Archive';

  @override
  String get categoryNameRequired => 'Category name is required';

  @override
  String get categoryNameTooLong => 'Category name is too long';

  @override
  String get invalidColorHex => 'Invalid hex color, use format #RRGGBB';

  @override
  String get confirmDeleteTitle => 'Delete Transaction';

  @override
  String get confirmDeleteBody =>
      'This transaction will be permanently removed. Continue?';

  @override
  String get confirmDeleteBudgetTitle => 'Delete Budget';

  @override
  String get confirmDeleteBudgetBody =>
      'This budget will be permanently removed. Continue?';

  @override
  String get cancelLabel => 'Cancel';

  @override
  String get deleteActionLabel => 'Delete';

  @override
  String get updateActionLabel => 'Update';

  @override
  String get restoreActionLabel => 'Restore';
}
