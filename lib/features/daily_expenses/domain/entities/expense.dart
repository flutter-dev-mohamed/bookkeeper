class Expense {
  int id;
  ExpenseType type;
  double amount;
  String note;
  String createdAt;

  Expense({
    required this.id,
    required this.type,
    required this.amount,
    required this.note,
    required this.createdAt,
  });

  Expense copyWith({
    int? id,
    ExpenseType? type,
    double? amount,
    String? note,
    String? createdAt,
  }) {
    return Expense(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

enum ExpenseType { marketing, transport, rent, other }
