import 'package:fin_sage/data/datasources/local/db_migration_service.dart';
import 'package:fin_sage/data/datasources/local/drift_query_service.dart';
import 'package:fin_sage/data/datasources/local/local_database_datasource.dart';
import 'package:fin_sage/data/datasources/local/secure_key_service.dart';
import 'package:fin_sage/data/models/recurring_transaction_model.dart';
import 'package:fin_sage/data/models/transaction_model.dart';
import 'package:fin_sage/data/repositories/impl/recurring_transaction_repository_impl.dart';
import 'package:fin_sage/data/repositories/impl/transaction_repository_impl.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rrule/rrule.dart';
import 'package:workmanager/workmanager.dart';

class RecurringTransactionScheduler {
  static const String taskName = 'finsage.recurring_transactions';
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) {
      return;
    }
    await Workmanager().initialize(_callbackDispatcher, isInDebugMode: false);
    _initialized = true;
  }

  static Future<void> scheduleDaily() async {
    await Workmanager().registerPeriodicTask(
      taskName,
      taskName,
      frequency: const Duration(hours: 24),
      initialDelay: const Duration(minutes: 5),
      constraints: Constraints(networkType: NetworkType.not_required),
      existingWorkPolicy: ExistingWorkPolicy.keep,
    );
  }
}

@pragma('vm:entry-point')
void _callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task != RecurringTransactionScheduler.taskName) {
      return Future<bool>.value(false);
    }
    return _processRecurringTransactions();
  });
}

@pragma('vm:entry-point')
Future<bool> _processRecurringTransactions() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    // Manual DI because this is a separate isolate
    const secureStorage = FlutterSecureStorage();
    final localDb = LocalDatabaseDataSource(
        SecureKeyService(secureStorage), DbMigrationService());
    final transactionRepo =
        TransactionRepositoryImpl(localDb, DriftQueryService(localDb));
    final recurringRepo = RecurringTransactionRepositoryImpl(localDb);

    final now = DateTime.now();
    final recurringTxs = await recurringRepo.getRecurringTransactions();

    for (final recurringTx in recurringTxs) {
      var dueDate = recurringTx.nextOccurrenceDate;
      var processedCount = 0;
      var exhausted = false;
      const maxCatchUpPerTemplate = 24;

      while (!dueDate.isAfter(now) && processedCount < maxCatchUpPerTemplate) {
        final newTransaction = TransactionModel(
          id: null,
          title: recurringTx.title,
          amount: recurringTx.amount,
          date: dueDate,
          categoryId: recurringTx.categoryId,
          accountId: recurringTx.accountId,
          type: recurringTx.type,
        );

        await transactionRepo.saveTransaction(newTransaction);
        processedCount++;
        final nextDate = _nextOccurrenceAfter(
          rule: recurringTx.recurrenceRule,
          occurrenceDate: dueDate,
        );
        if (nextDate == null) {
          exhausted = true;
          break;
        }
        dueDate = nextDate;
      }

      if (processedCount == 0) {
        continue;
      }

      if (exhausted && recurringTx.id != null) {
        await recurringRepo.deleteRecurringTransaction(recurringTx.id!);
        continue;
      }

      final updatedRecurringTx = RecurringTransactionModel(
        id: recurringTx.id,
        title: recurringTx.title,
        amount: recurringTx.amount,
        type: recurringTx.type,
        recurrenceRule: recurringTx.recurrenceRule,
        nextOccurrenceDate: dueDate,
        categoryId: recurringTx.categoryId,
        accountId: recurringTx.accountId,
      );

      await recurringRepo.updateRecurringTransaction(updatedRecurringTx);
    }
    return true;
  } catch (e) {
    // In a real app, you'd log this error to a remote service
    return false;
  }
}

DateTime? _nextOccurrenceAfter({
  required String rule,
  required DateTime occurrenceDate,
}) {
  final recurrenceRule = RecurrenceRule.fromString(rule);
  final instances = recurrenceRule
      .getInstances(
        start: occurrenceDate,
        after: occurrenceDate,
      )
      .iterator;
  return instances.moveNext() ? instances.current : null;
}
