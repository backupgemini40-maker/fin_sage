import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'FinSage';

  @override
  String get unexpectedError => 'Terjadi kesalahan tak terduga';

  @override
  String get databaseOpenFailed => 'Gagal membuka data lokal terenkripsi. Ini bisa terjadi setelah install ulang. Pulihkan dari backup atau reset data lokal.';

  @override
  String get recoveryWelcomeTitle => 'Selamat datang kembali';

  @override
  String get recoveryWelcomeBody => 'Kami mendeteksi data lokal terenkripsi dari instalasi sebelumnya. Pilih mulai baru atau pulihkan dari backup.';

  @override
  String get recoveryStartNewAction => 'Mulai Baru';

  @override
  String get recoveryRestoreAction => 'Pulihkan dari Backup';

  @override
  String get signInGoogle => 'Masuk dengan Google';

  @override
  String get googleSignInConfigMissing => 'GOOGLE_SERVER_CLIENT_ID belum diisi. Tambahkan di dart-define untuk autentikasi backup Google Drive.';

  @override
  String get googleAuthUnavailable => 'Autentikasi Google tidak tersedia. Silakan login ulang lalu coba lagi.';

  @override
  String get googleSignInDeveloperError => 'Konfigurasi Google Sign-In tidak valid (OAuth/SHA-1 tidak cocok). Periksa kredensial Firebase dan Google Cloud.';

  @override
  String get googleSignInTroubleshootTitle => 'Detail setup Google Sign-In';

  @override
  String get googleSignInTroubleshootHint => 'Gunakan Android package dan SHA-1/SHA-256 keystore di bawah ini untuk dicocokkan ke kredensial OAuth Firebase dan Google Cloud.';

  @override
  String get androidApplicationIdLabel => 'Android applicationId';

  @override
  String get serverClientIdConfiguredLabel => 'GOOGLE_SERVER_CLIENT_ID terkonfigurasi';

  @override
  String get clientIdConfiguredLabel => 'GOOGLE_CLIENT_ID terkonfigurasi';

  @override
  String get configuredYes => 'Ya';

  @override
  String get configuredNo => 'Tidak';

  @override
  String get dashboardTitle => 'Dasbor';

  @override
  String get totalBalance => 'Total Saldo';

  @override
  String get monthlyIncome => 'Pemasukan Bulanan';

  @override
  String get monthlyExpense => 'Pengeluaran Bulanan';

  @override
  String get monthlyTransactions => 'Transaksi Bulanan';

  @override
  String get balanceTrendChartLabel => 'Grafik tren saldo';

  @override
  String get recentTransactions => 'Transaksi Terbaru';

  @override
  String get transactionsTitle => 'Transaksi';

  @override
  String get budgetsTitle => 'Anggaran';

  @override
  String get reportsTitle => 'Laporan';

  @override
  String get settingsTitle => 'Pengaturan';

  @override
  String get accountsTitle => 'Akun';

  @override
  String get addAccount => 'Tambah Akun';

  @override
  String get editAccount => 'Edit Akun';

  @override
  String get accountLabel => 'Akun';

  @override
  String get accountNameLabel => 'Nama Akun';

  @override
  String get accountTypeLabel => 'Tipe Akun';

  @override
  String get accountTypeCash => 'Tunai';

  @override
  String get accountTypeBank => 'Bank';

  @override
  String get accountTypeWallet => 'Dompet';

  @override
  String get accountTypeSavings => 'Tabungan';

  @override
  String get accountTypeCredit => 'Kredit';

  @override
  String get initialBalanceLabel => 'Saldo Awal';

  @override
  String get currentBalanceLabel => 'Saldo Saat Ini';

  @override
  String get accountColorLabel => 'Warna Aksen';

  @override
  String totalAccounts(Object count) {
    return '$count akun';
  }

  @override
  String get emptyAccounts => 'Belum ada akun';

  @override
  String get emptyAccountsSubtitle => 'Buat akun untuk melacak tunai, bank, dompet, dan kartu.';

  @override
  String get archiveAccountTitle => 'Arsipkan Akun';

  @override
  String archiveAccountBody(Object name) {
    return 'Arsipkan akun \"$name\"?';
  }

  @override
  String get accountArchived => 'Akun berhasil diarsipkan';

  @override
  String get accountAlreadyExists => 'Akun sudah ada';

  @override
  String get accountNotFound => 'Akun tidak ditemukan';

  @override
  String get accountBalanceNotZero => 'Pindahkan atau kosongkan saldo akun sebelum diarsipkan';

  @override
  String get defaultAccountArchiveBlocked => 'Akun default tidak bisa diarsipkan';

  @override
  String get dashboardAccountSnapshot => 'Ringkasan Akun';

  @override
  String get cashFlowHealthTitle => 'Kesehatan Arus Kas';

  @override
  String get monthlyNetCashFlow => 'Arus Kas Bersih Bulanan';

  @override
  String get savingsRateLabel => 'Rasio Simpan';

  @override
  String get positiveCashFlowInsight => 'Arus kas bulan ini positif';

  @override
  String get negativeCashFlowInsight => 'Pengeluaran bulan ini melebihi pemasukan';

  @override
  String get operationInProgress => 'Memproses permintaan...';

  @override
  String get appInfoTitle => 'Info Aplikasi';

  @override
  String get appVersionLabel => 'Versi';

  @override
  String get refreshLabel => 'Muat Ulang';

  @override
  String get addTransaction => 'Tambah Transaksi';

  @override
  String get emptyTransactions => 'Belum ada transaksi';

  @override
  String get searchTransactions => 'Cari transaksi';

  @override
  String get noMatchingTransactions => 'Tidak ada transaksi yang cocok';

  @override
  String get titleLabel => 'Judul';

  @override
  String get amountLabel => 'Jumlah';

  @override
  String get dateLabel => 'Tanggal';

  @override
  String get allType => 'Semua';

  @override
  String get transactionTypeLabel => 'Tipe Transaksi';

  @override
  String get incomeType => 'Pemasukan';

  @override
  String get expenseType => 'Pengeluaran';

  @override
  String get saveLabel => 'Simpan';

  @override
  String get requiredField => 'Kolom ini wajib diisi';

  @override
  String get amountRequired => 'Jumlah wajib diisi';

  @override
  String get amountInvalid => 'Masukkan jumlah yang valid';

  @override
  String get amountMustBePositive => 'Jumlah harus lebih dari nol';

  @override
  String get amountTooLarge => 'Jumlah terlalu besar';

  @override
  String get dateRequired => 'Tanggal wajib diisi';

  @override
  String get dateFutureNotAllowed => 'Tanggal masa depan tidak diizinkan';

  @override
  String get noBudgetYet => 'Belum ada anggaran';

  @override
  String get categoryLabel => 'Kategori';

  @override
  String get usedLabel => 'Terpakai';

  @override
  String get limitLabel => 'Batas';

  @override
  String get exportPdf => 'Ekspor PDF';

  @override
  String get exportCsv => 'Ekspor CSV';

  @override
  String get noDataToExport => 'Tidak ada data untuk diekspor';

  @override
  String csvSaved(Object path) {
    return 'CSV tersimpan: $path';
  }

  @override
  String selectedMonthLabel(Object month) {
    return 'Bulan: $month';
  }

  @override
  String monthlyReportTitle(Object month) {
    return 'Laporan FinSage - $month';
  }

  @override
  String get reportPdfDefaultTitle => 'Laporan Keuangan FinSage';

  @override
  String get reportPdfTransactionsLabel => 'Transaksi';

  @override
  String get reportPdfIncomeLabel => 'Pemasukan';

  @override
  String get reportPdfExpenseLabel => 'Pengeluaran';

  @override
  String get reportPdfNetBalanceLabel => 'Saldo Bersih';

  @override
  String get reportCsvHeaderId => 'id';

  @override
  String get reportCsvHeaderTitle => 'judul';

  @override
  String get reportCsvHeaderAmount => 'jumlah';

  @override
  String get reportCsvHeaderType => 'tipe';

  @override
  String get reportCsvHeaderDate => 'tanggal';

  @override
  String get reportCsvHeaderCategoryId => 'kategori_id';

  @override
  String get reportCsvHeaderAccountId => 'akun_id';

  @override
  String transactionCount(Object count) {
    return '$count transaksi';
  }

  @override
  String get netBalance => 'Saldo Bersih';

  @override
  String get darkMode => 'Mode Gelap';

  @override
  String get budgetNotificationsLabel => 'Notifikasi Anggaran';

  @override
  String get languageLabel => 'Bahasa';

  @override
  String get systemDefault => 'Ikuti Sistem';

  @override
  String get englishLanguage => 'Inggris';

  @override
  String get indonesianLanguage => 'Indonesia';

  @override
  String get backupNow => 'Backup Sekarang';

  @override
  String lastBackupLabel(Object value) {
    return 'Backup terakhir: $value';
  }

  @override
  String get noBackupHistory => 'Belum ada riwayat backup';

  @override
  String get restorePreview => 'Pratinjau Restore';

  @override
  String get noBackupFiles => 'Belum ada file backup';

  @override
  String get backupCompleted => 'Backup berhasil';

  @override
  String get autoBackupValidationScheduled => 'Validasi auto-backup telah dijadwalkan';

  @override
  String get validateAutoBackupLabel => 'Validasi Auto Backup';

  @override
  String get autoBackupStatusTitle => 'Status Auto Backup';

  @override
  String get autoBackupNeverRun => 'Percobaan terakhir: belum pernah';

  @override
  String get autoBackupNoSuccessYet => 'Sukses terakhir: belum ada';

  @override
  String autoBackupLastAttempt(Object value) {
    return 'Percobaan terakhir: $value';
  }

  @override
  String autoBackupLastSuccess(Object value) {
    return 'Sukses terakhir: $value';
  }

  @override
  String autoBackupLastError(Object value) {
    return 'Error terakhir: $value';
  }

  @override
  String get restorePreviewLoaded => 'Pratinjau restore berhasil dimuat';

  @override
  String get restoreCompleted => 'Restore berhasil';

  @override
  String get restoreConfirmTitle => 'Konfirmasi Restore';

  @override
  String get restoreConfirmBody => 'Restore backup akan menimpa data lokal. Lanjutkan?';

  @override
  String get backupInvalidFile => 'File backup tidak valid atau rusak';

  @override
  String get backupChecksumMismatch => 'Pemeriksaan integritas backup gagal (checksum tidak cocok)';

  @override
  String get signOutLabel => 'Keluar';

  @override
  String get signOutConfirmBody => 'Kamu akan kembali ke layar login. Lanjutkan?';

  @override
  String get resetLocalDataLabel => 'Reset Data Lokal';

  @override
  String get resetLocalDataConfirmBody => 'Ini akan menghapus transaksi, anggaran, dan kategori kustom lokal. Lanjutkan?';

  @override
  String get resetActionLabel => 'Reset';

  @override
  String get localDataResetCompleted => 'Data lokal berhasil di-reset';

  @override
  String get manageCategories => 'Kelola kategori';

  @override
  String get addCategory => 'Tambah Kategori';

  @override
  String get categoryNameLabel => 'Nama Kategori';

  @override
  String get colorHexLabel => 'Warna (Hex)';

  @override
  String get iconLabel => 'Nama Ikon';

  @override
  String get categoryCreated => 'Kategori berhasil dibuat';

  @override
  String get categoryExists => 'Kategori sudah ada';

  @override
  String get categoryInUse => 'Kategori masih digunakan oleh transaksi';

  @override
  String get defaultCategoryArchiveBlocked => 'Kategori default tidak bisa diarsipkan';

  @override
  String get archiveCategoryTitle => 'Arsipkan Kategori';

  @override
  String archiveCategoryBody(Object name) {
    return 'Arsipkan kategori \"$name\"?';
  }

  @override
  String get archiveActionLabel => 'Arsipkan';

  @override
  String get categoryNameRequired => 'Nama kategori wajib diisi';

  @override
  String get categoryNameTooLong => 'Nama kategori terlalu panjang';

  @override
  String get invalidColorHex => 'Hex warna tidak valid, gunakan format #RRGGBB';

  @override
  String get confirmDeleteTitle => 'Hapus Transaksi';

  @override
  String get confirmDeleteBody => 'Transaksi ini akan dihapus permanen. Lanjutkan?';

  @override
  String get confirmDeleteBudgetTitle => 'Hapus Anggaran';

  @override
  String get confirmDeleteBudgetBody => 'Anggaran ini akan dihapus permanen. Lanjutkan?';

  @override
  String get cancelLabel => 'Batal';

  @override
  String get deleteActionLabel => 'Hapus';

  @override
  String get updateActionLabel => 'Perbarui';

  @override
  String get restoreActionLabel => 'Restore';

  @override
  String get recurringTransactionsTitle => 'Transaksi Berulang';

  @override
  String get recurringTransactionsSubtitle => 'Kelola transaksi otomatis';

  @override
  String get addRecurringTransaction => 'Tambah Transaksi Berulang';

  @override
  String get editRecurringTransaction => 'Edit Transaksi Berulang';

  @override
  String get recurringEmptyTitle => 'Belum ada transaksi berulang';

  @override
  String get recurringEmptySubtitle => 'Otomatiskan langganan, tagihan, gaji, dan transfer.';

  @override
  String get recurrenceLabel => 'Pengulangan';

  @override
  String get recurrenceDaily => 'Harian';

  @override
  String get recurrenceWeekly => 'Mingguan';

  @override
  String get recurrenceMonthly => 'Bulanan';

  @override
  String get recurrenceYearly => 'Tahunan';

  @override
  String get recurrenceCustom => 'Aturan Kustom';

  @override
  String get recurrenceRuleLabel => 'Aturan';

  @override
  String get rruleLabel => 'RRULE';

  @override
  String get invalidRRule => 'RRULE tidak valid';

  @override
  String get accountAndCategoryRequired => 'Buat minimal satu kategori dan satu akun terlebih dahulu.';
}
