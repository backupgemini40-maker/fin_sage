import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'FinSage'**
  String get appTitle;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'Unexpected error'**
  String get unexpectedError;

  /// No description provided for @signInGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get signInGoogle;

  /// No description provided for @googleSignInConfigMissing.
  ///
  /// In en, this message translates to:
  /// **'GOOGLE_SERVER_CLIENT_ID is not set. Define it in dart-define for Google Drive backup auth.'**
  String get googleSignInConfigMissing;

  /// No description provided for @googleAuthUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Google authentication is unavailable. Please sign in again and retry.'**
  String get googleAuthUnavailable;

  /// No description provided for @googleSignInDeveloperError.
  ///
  /// In en, this message translates to:
  /// **'Google Sign-In configuration is invalid (OAuth/SHA-1 mismatch). Verify Firebase and Google Cloud credentials.'**
  String get googleSignInDeveloperError;

  /// No description provided for @googleSignInTroubleshootTitle.
  ///
  /// In en, this message translates to:
  /// **'Google Sign-In setup details'**
  String get googleSignInTroubleshootTitle;

  /// No description provided for @googleSignInTroubleshootHint.
  ///
  /// In en, this message translates to:
  /// **'Use the Android package and keystore SHA-1/SHA-256 values below to match Firebase and Google Cloud OAuth credentials.'**
  String get googleSignInTroubleshootHint;

  /// No description provided for @androidApplicationIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Android applicationId'**
  String get androidApplicationIdLabel;

  /// No description provided for @serverClientIdConfiguredLabel.
  ///
  /// In en, this message translates to:
  /// **'GOOGLE_SERVER_CLIENT_ID configured'**
  String get serverClientIdConfiguredLabel;

  /// No description provided for @clientIdConfiguredLabel.
  ///
  /// In en, this message translates to:
  /// **'GOOGLE_CLIENT_ID configured'**
  String get clientIdConfiguredLabel;

  /// No description provided for @configuredYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get configuredYes;

  /// No description provided for @configuredNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get configuredNo;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboardTitle;

  /// No description provided for @totalBalance.
  ///
  /// In en, this message translates to:
  /// **'Total Balance'**
  String get totalBalance;

  /// No description provided for @monthlyIncome.
  ///
  /// In en, this message translates to:
  /// **'Monthly Income'**
  String get monthlyIncome;

  /// No description provided for @monthlyExpense.
  ///
  /// In en, this message translates to:
  /// **'Monthly Expense'**
  String get monthlyExpense;

  /// No description provided for @monthlyTransactions.
  ///
  /// In en, this message translates to:
  /// **'Monthly Transactions'**
  String get monthlyTransactions;

  /// No description provided for @balanceTrendChartLabel.
  ///
  /// In en, this message translates to:
  /// **'Balance trend chart'**
  String get balanceTrendChartLabel;

  /// No description provided for @recentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get recentTransactions;

  /// No description provided for @transactionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactionsTitle;

  /// No description provided for @budgetsTitle.
  ///
  /// In en, this message translates to:
  /// **'Budgets'**
  String get budgetsTitle;

  /// No description provided for @reportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reportsTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @operationInProgress.
  ///
  /// In en, this message translates to:
  /// **'Processing request...'**
  String get operationInProgress;

  /// No description provided for @appInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'App Info'**
  String get appInfoTitle;

  /// No description provided for @appVersionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get appVersionLabel;

  /// No description provided for @refreshLabel.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refreshLabel;

  /// No description provided for @addTransaction.
  ///
  /// In en, this message translates to:
  /// **'Add Transaction'**
  String get addTransaction;

  /// No description provided for @emptyTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get emptyTransactions;

  /// No description provided for @searchTransactions.
  ///
  /// In en, this message translates to:
  /// **'Search transactions'**
  String get searchTransactions;

  /// No description provided for @noMatchingTransactions.
  ///
  /// In en, this message translates to:
  /// **'No matching transactions'**
  String get noMatchingTransactions;

  /// No description provided for @titleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get titleLabel;

  /// No description provided for @amountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amountLabel;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @allType.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allType;

  /// No description provided for @transactionTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Transaction Type'**
  String get transactionTypeLabel;

  /// No description provided for @incomeType.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get incomeType;

  /// No description provided for @expenseType.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expenseType;

  /// No description provided for @saveLabel.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveLabel;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get requiredField;

  /// No description provided for @amountRequired.
  ///
  /// In en, this message translates to:
  /// **'Amount is required'**
  String get amountRequired;

  /// No description provided for @amountInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get amountInvalid;

  /// No description provided for @amountMustBePositive.
  ///
  /// In en, this message translates to:
  /// **'Amount must be positive'**
  String get amountMustBePositive;

  /// No description provided for @amountTooLarge.
  ///
  /// In en, this message translates to:
  /// **'Amount is too large'**
  String get amountTooLarge;

  /// No description provided for @dateRequired.
  ///
  /// In en, this message translates to:
  /// **'Date is required'**
  String get dateRequired;

  /// No description provided for @dateFutureNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'Future date is not allowed'**
  String get dateFutureNotAllowed;

  /// No description provided for @noBudgetYet.
  ///
  /// In en, this message translates to:
  /// **'No budget configured'**
  String get noBudgetYet;

  /// No description provided for @categoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryLabel;

  /// No description provided for @usedLabel.
  ///
  /// In en, this message translates to:
  /// **'Used'**
  String get usedLabel;

  /// No description provided for @limitLabel.
  ///
  /// In en, this message translates to:
  /// **'Limit'**
  String get limitLabel;

  /// No description provided for @exportPdf.
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get exportPdf;

  /// No description provided for @exportCsv.
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get exportCsv;

  /// No description provided for @noDataToExport.
  ///
  /// In en, this message translates to:
  /// **'No data to export'**
  String get noDataToExport;

  /// No description provided for @csvSaved.
  ///
  /// In en, this message translates to:
  /// **'CSV saved: {path}'**
  String csvSaved(Object path);

  /// No description provided for @selectedMonthLabel.
  ///
  /// In en, this message translates to:
  /// **'Month: {month}'**
  String selectedMonthLabel(Object month);

  /// No description provided for @monthlyReportTitle.
  ///
  /// In en, this message translates to:
  /// **'FinSage Report - {month}'**
  String monthlyReportTitle(Object month);

  /// No description provided for @reportPdfDefaultTitle.
  ///
  /// In en, this message translates to:
  /// **'FinSage Financial Report'**
  String get reportPdfDefaultTitle;

  /// No description provided for @reportPdfTransactionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get reportPdfTransactionsLabel;

  /// No description provided for @reportPdfIncomeLabel.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get reportPdfIncomeLabel;

  /// No description provided for @reportPdfExpenseLabel.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get reportPdfExpenseLabel;

  /// No description provided for @reportPdfNetBalanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Net Balance'**
  String get reportPdfNetBalanceLabel;

  /// No description provided for @reportCsvHeaderId.
  ///
  /// In en, this message translates to:
  /// **'id'**
  String get reportCsvHeaderId;

  /// No description provided for @reportCsvHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'title'**
  String get reportCsvHeaderTitle;

  /// No description provided for @reportCsvHeaderAmount.
  ///
  /// In en, this message translates to:
  /// **'amount'**
  String get reportCsvHeaderAmount;

  /// No description provided for @reportCsvHeaderType.
  ///
  /// In en, this message translates to:
  /// **'type'**
  String get reportCsvHeaderType;

  /// No description provided for @reportCsvHeaderDate.
  ///
  /// In en, this message translates to:
  /// **'date'**
  String get reportCsvHeaderDate;

  /// No description provided for @reportCsvHeaderCategoryId.
  ///
  /// In en, this message translates to:
  /// **'category_id'**
  String get reportCsvHeaderCategoryId;

  /// No description provided for @transactionCount.
  ///
  /// In en, this message translates to:
  /// **'{count} transactions'**
  String transactionCount(Object count);

  /// No description provided for @netBalance.
  ///
  /// In en, this message translates to:
  /// **'Net Balance'**
  String get netBalance;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @budgetNotificationsLabel.
  ///
  /// In en, this message translates to:
  /// **'Budget Notifications'**
  String get budgetNotificationsLabel;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// No description provided for @englishLanguage.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get englishLanguage;

  /// No description provided for @indonesianLanguage.
  ///
  /// In en, this message translates to:
  /// **'Indonesian'**
  String get indonesianLanguage;

  /// No description provided for @backupNow.
  ///
  /// In en, this message translates to:
  /// **'Backup Now'**
  String get backupNow;

  /// No description provided for @lastBackupLabel.
  ///
  /// In en, this message translates to:
  /// **'Last backup: {value}'**
  String lastBackupLabel(Object value);

  /// No description provided for @noBackupHistory.
  ///
  /// In en, this message translates to:
  /// **'No backup history yet'**
  String get noBackupHistory;

  /// No description provided for @restorePreview.
  ///
  /// In en, this message translates to:
  /// **'Restore Preview'**
  String get restorePreview;

  /// No description provided for @noBackupFiles.
  ///
  /// In en, this message translates to:
  /// **'No backup files found'**
  String get noBackupFiles;

  /// No description provided for @backupCompleted.
  ///
  /// In en, this message translates to:
  /// **'Backup completed successfully'**
  String get backupCompleted;

  /// No description provided for @autoBackupValidationScheduled.
  ///
  /// In en, this message translates to:
  /// **'Auto-backup validation has been scheduled'**
  String get autoBackupValidationScheduled;

  /// No description provided for @validateAutoBackupLabel.
  ///
  /// In en, this message translates to:
  /// **'Validate Auto Backup'**
  String get validateAutoBackupLabel;

  /// No description provided for @autoBackupStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Auto Backup Status'**
  String get autoBackupStatusTitle;

  /// No description provided for @autoBackupNeverRun.
  ///
  /// In en, this message translates to:
  /// **'Last attempt: never'**
  String get autoBackupNeverRun;

  /// No description provided for @autoBackupNoSuccessYet.
  ///
  /// In en, this message translates to:
  /// **'Last success: not yet'**
  String get autoBackupNoSuccessYet;

  /// No description provided for @autoBackupLastAttempt.
  ///
  /// In en, this message translates to:
  /// **'Last attempt: {value}'**
  String autoBackupLastAttempt(Object value);

  /// No description provided for @autoBackupLastSuccess.
  ///
  /// In en, this message translates to:
  /// **'Last success: {value}'**
  String autoBackupLastSuccess(Object value);

  /// No description provided for @autoBackupLastError.
  ///
  /// In en, this message translates to:
  /// **'Last error: {value}'**
  String autoBackupLastError(Object value);

  /// No description provided for @restorePreviewLoaded.
  ///
  /// In en, this message translates to:
  /// **'Restore preview loaded'**
  String get restorePreviewLoaded;

  /// No description provided for @restoreCompleted.
  ///
  /// In en, this message translates to:
  /// **'Restore completed successfully'**
  String get restoreCompleted;

  /// No description provided for @restoreConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Restore'**
  String get restoreConfirmTitle;

  /// No description provided for @restoreConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Restoring backup will overwrite local data. Continue?'**
  String get restoreConfirmBody;

  /// No description provided for @backupInvalidFile.
  ///
  /// In en, this message translates to:
  /// **'Backup file is invalid or corrupted'**
  String get backupInvalidFile;

  /// No description provided for @backupChecksumMismatch.
  ///
  /// In en, this message translates to:
  /// **'Backup integrity check failed (checksum mismatch)'**
  String get backupChecksumMismatch;

  /// No description provided for @signOutLabel.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOutLabel;

  /// No description provided for @signOutConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'You will be returned to login screen. Continue?'**
  String get signOutConfirmBody;

  /// No description provided for @resetLocalDataLabel.
  ///
  /// In en, this message translates to:
  /// **'Reset Local Data'**
  String get resetLocalDataLabel;

  /// No description provided for @resetLocalDataConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This will remove local transactions, budgets, and custom categories. Continue?'**
  String get resetLocalDataConfirmBody;

  /// No description provided for @resetActionLabel.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get resetActionLabel;

  /// No description provided for @localDataResetCompleted.
  ///
  /// In en, this message translates to:
  /// **'Local data has been reset'**
  String get localDataResetCompleted;

  /// No description provided for @manageCategories.
  ///
  /// In en, this message translates to:
  /// **'Manage categories'**
  String get manageCategories;

  /// No description provided for @addCategory.
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get addCategory;

  /// No description provided for @categoryNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Category Name'**
  String get categoryNameLabel;

  /// No description provided for @colorHexLabel.
  ///
  /// In en, this message translates to:
  /// **'Color (Hex)'**
  String get colorHexLabel;

  /// No description provided for @iconLabel.
  ///
  /// In en, this message translates to:
  /// **'Icon Name'**
  String get iconLabel;

  /// No description provided for @categoryCreated.
  ///
  /// In en, this message translates to:
  /// **'Category created'**
  String get categoryCreated;

  /// No description provided for @categoryExists.
  ///
  /// In en, this message translates to:
  /// **'Category already exists'**
  String get categoryExists;

  /// No description provided for @categoryInUse.
  ///
  /// In en, this message translates to:
  /// **'Category is still used by transactions'**
  String get categoryInUse;

  /// No description provided for @defaultCategoryArchiveBlocked.
  ///
  /// In en, this message translates to:
  /// **'Default category cannot be archived'**
  String get defaultCategoryArchiveBlocked;

  /// No description provided for @archiveCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Archive Category'**
  String get archiveCategoryTitle;

  /// No description provided for @archiveCategoryBody.
  ///
  /// In en, this message translates to:
  /// **'Archive category \"{name}\"?'**
  String archiveCategoryBody(Object name);

  /// No description provided for @archiveActionLabel.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archiveActionLabel;

  /// No description provided for @categoryNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Category name is required'**
  String get categoryNameRequired;

  /// No description provided for @categoryNameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Category name is too long'**
  String get categoryNameTooLong;

  /// No description provided for @invalidColorHex.
  ///
  /// In en, this message translates to:
  /// **'Invalid hex color, use format #RRGGBB'**
  String get invalidColorHex;

  /// No description provided for @confirmDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Transaction'**
  String get confirmDeleteTitle;

  /// No description provided for @confirmDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'This transaction will be permanently removed. Continue?'**
  String get confirmDeleteBody;

  /// No description provided for @confirmDeleteBudgetTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Budget'**
  String get confirmDeleteBudgetTitle;

  /// No description provided for @confirmDeleteBudgetBody.
  ///
  /// In en, this message translates to:
  /// **'This budget will be permanently removed. Continue?'**
  String get confirmDeleteBudgetBody;

  /// No description provided for @cancelLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelLabel;

  /// No description provided for @deleteActionLabel.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteActionLabel;

  /// No description provided for @updateActionLabel.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get updateActionLabel;

  /// No description provided for @restoreActionLabel.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restoreActionLabel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
