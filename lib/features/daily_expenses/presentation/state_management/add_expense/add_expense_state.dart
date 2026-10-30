part of 'add_expense_cubit.dart';

@immutable
sealed class AddExpenseState {}

final class AddExpenseInitial extends AddExpenseState {
  final Expense expense;

  AddExpenseInitial({required this.expense});
}

final class AddExpenseLoading extends AddExpenseState {}

final class AddExpenseSuccess extends AddExpenseState {}

final class AddExpenseFailure extends AddExpenseState {
  final String message;

  AddExpenseFailure({required this.message});
}
