part of 'expenses_cubit.dart';

@immutable
sealed class ExpensesState {}

final class ExpensesInitial extends ExpensesState {}

final class ExpensesLoading extends ExpensesState {}

final class ExpensesFailure extends ExpensesState {
  final String message;

  ExpensesFailure({required this.message});
}

final class ExpensesLoaded extends ExpensesState {
  final List<Expense> expenses;

  ExpensesLoaded({required this.expenses});

  List<Expense> get marketingExpenses =>
      expenses.where((e) => e.type == ExpenseType.marketing).toList();

  List<Expense> get transportExpenses =>
      expenses.where((e) => e.type == ExpenseType.transport).toList();

  List<Expense> get rentExpenses =>
      expenses.where((e) => e.type == ExpenseType.rent).toList();

  List<Expense> get otherExpenses =>
      expenses.where((e) => e.type == ExpenseType.other).toList();

  double totalAmountFor(ExpenseType type) => expenses
      .where((e) => e.type == type)
      .fold(0.0, (sum, item) => sum + item.amount);

  double get totalAllExpenses =>
      expenses.fold(0.0, (sum, item) => sum + item.amount);
}
