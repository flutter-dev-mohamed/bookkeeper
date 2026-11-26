import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shagaf_ledger/core/common/use_cases/use_cases.dart';
import 'package:shagaf_ledger/features/daily_expenses/domain/entities/expense.dart';
import 'package:shagaf_ledger/features/daily_expenses/domain/use_cases/delete_expense.dart';
import 'package:shagaf_ledger/features/daily_expenses/domain/use_cases/get_all_expense.dart';
import 'package:shagaf_ledger/features/daily_expenses/presentation/state_management/expenses/expenses_effect.dart';

part 'expenses_state.dart';

class ExpensesCubit extends Cubit<ExpensesState> {
  final GetAllExpense _getAllExpense;
  final DeleteExpense _deleteExpense;

  ExpensesCubit({required this._getAllExpense, required this._deleteExpense})
    : super(ExpensesInitial()) {
    _loadExpenses();
  }

  @override
  Future<void> close() {
    _effectsController.close();
    return super.close();
  }

  final _effectsController = StreamController<ExpensesEffect>.broadcast();

  Stream<ExpensesEffect> get effects => _effectsController.stream;

  void _loadExpenses() async {
    // go to loading
    emit(ExpensesLoading());

    // Load the expenses from db
    final res = await _getAllExpense(NoParams());

    res.fold(
      (error) => emit(ExpensesFailure(message: error.message)),
      (expensesList) => emit(ExpensesLoaded(expenses: expensesList)),
    );
  }

  void editExpense(Expense newExpense, int index) {
    // TODO: IMPLEMENT EDITING EXPENSE
    final currentState = state;
    if (currentState is! ExpensesLoaded) return;

    List<Expense> expenses = currentState.expenses;

    expenses[index] = newExpense;

    emit(ExpensesLoaded(expenses: expenses));
  }

  void deleteExpense(int expenseIndex) async {
    final currentState = state;
    if (currentState is! ExpensesLoaded) return;

    List<Expense> expenses = currentState.expenses;

    final res = await _deleteExpense(expenses[expenseIndex].id);

    res.fold(
      (error) {
        // send effect to show an error dialog
      },
      (_) {
        expenses.removeAt(expenseIndex);
        emit(ExpensesLoaded(expenses: expenses));
      },
    );
  }
}
