import 'package:shagaf_ledger/features/daily_expenses/domain/entities/expense.dart';

class ExpenseModel extends Expense {
  ExpenseModel({
    required super.id,
    required super.type,
    required super.amount,
    required super.note,
    required super.createdAt,
  });

  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
      id: map['id'] as int,
      type: ExpenseType.values[map['type'] as int],
      amount: (map['amount'] as num).toDouble(),
      note: map['note'] as String? ?? '',
      createdAt: map['created_at'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type.index,
      'amount': amount,
      'note': note,
      'created_at': createdAt,
    };
  }

  factory ExpenseModel.fromEntity(Expense expense) {
    return ExpenseModel(
      id: expense.id,
      type: expense.type,
      amount: expense.amount,
      note: expense.note,
      createdAt: expense.createdAt,
    );
  }
}
