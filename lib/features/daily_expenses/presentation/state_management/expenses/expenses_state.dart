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
}
