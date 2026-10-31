import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shagaf_ledger/core/common/use_cases/use_cases.dart';
import 'package:shagaf_ledger/features/daily_expenses/domain/entities/expense.dart';
import 'package:shagaf_ledger/features/daily_expenses/domain/use_cases/get_all_expense.dart';

part 'expenses_state.dart';

class ExpensesCubit extends Cubit<ExpensesState> {
  final GetAllExpense _getAllExpense;

  ExpensesCubit({required this._getAllExpense}) : super(ExpensesInitial()) {
    loadExpenses();
  }

  void loadExpenses() async {
    // go to loading
    emit(ExpensesLoading());

    // Load the expenses from db
    final res = await _getAllExpense(NoParams());

    res.fold(
      (error) => emit(ExpensesFailure(message: error.message)),
      (expensesList) => emit(ExpensesLoaded(expenses: expensesList)),
    );
  }

  void addExpenseToStateList(Expense expense) {
    final currentState = state;
    if (currentState is! ExpensesLoaded) return;

    List expenses = currentState.expenses;

    expenses.insert(0, expense);
  }

  void editExpense(Expense newExpense, int index) {
    final currentState = state;
    if (currentState is! ExpensesLoaded) return;

    List<Expense> expenses = currentState.expenses;

    expenses[index] = newExpense;

    emit(ExpensesLoaded(expenses: expenses));
  }

  void deleteExpense(int expenseIndex) {
    final currentState = state;
    if (currentState is! ExpensesLoaded) return;

    List<Expense> expenses = currentState.expenses;

    expenses.removeAt(expenseIndex);

    emit(ExpensesLoaded(expenses: expenses));
  }
}
