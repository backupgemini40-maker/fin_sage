import 'package:equatable/equatable.dart';
import 'package:fin_sage/data/models/transaction_model.dart';

class RecurringTransactionModel extends Equatable {
  const RecurringTransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.recurrenceRule,
    required this.nextOccurrenceDate,
    required this.categoryId,
    required this.accountId,
  });

  final int? id;
  final String title;
  final double amount;
  final TransactionType type;
  final String recurrenceRule;
  final DateTime nextOccurrenceDate;
  final int categoryId;
  final int accountId;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type.name,
      'recurrence_rule': recurrenceRule,
      'next_occurrence_date': nextOccurrenceDate.toIso8601String(),
      'category_id': categoryId,
      'account_id': accountId,
    };
  }

  factory RecurringTransactionModel.fromMap(Map<String, dynamic> map) {
    return RecurringTransactionModel(
      id: map['id'] as int?,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
      type: TransactionType.values.byName(map['type'] as String),
      recurrenceRule: map['recurrence_rule'] as String,
      nextOccurrenceDate: DateTime.parse(map['next_occurrence_date'] as String),
      categoryId: map['category_id'] as int,
      accountId: map['account_id'] as int,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        amount,
        type,
        recurrenceRule,
        nextOccurrenceDate,
        categoryId,
        accountId,
      ];
}
