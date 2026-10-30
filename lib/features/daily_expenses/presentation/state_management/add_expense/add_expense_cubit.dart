import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/core/common/functions/date_formatting.dart';
import 'package:shagaf_ledger/features/daily_expenses/domain/entities/expense.dart';
import 'package:shagaf_ledger/features/daily_expenses/domain/use_cases/add_expense.dart';

part 'add_expense_state.dart';

class AddExpenseCubit extends Cubit<AddExpenseState> {
  final AddExpense _addExpense;

  AddExpenseCubit({required this._addExpense})
    : super(
        AddExpenseInitial(
          expense: Expense(
            id: 0,
            type: ExpenseType.rent,
            amount: 0.0,
            note: "",
            createdAt: dateFormatting(DateTime.now()),
          ),
        ),
      );

  // update state params
  void updateState({ExpenseType? type, double? amount, String? note}) {
    final currentState = state;

    if (currentState is AddExpenseInitial) {
      emit(
        AddExpenseInitial(
          expense: currentState.expense.copyWith(
            type: type,
            amount: amount,
            note: note,
          ),
        ),
      );
    }
  }

  // add expense
  Future<void> addExpense() async {
    final currentState = state;
    OPrint.lineY('CUBIT ADD EXPENSE');
    OPrint.y('Current State: $currentState');

    if (currentState is! AddExpenseInitial) {
      OPrint.r(
        '⚠️ Aborted: State is not AddExpenseInitial (Current: $currentState)',
      );
      return;
    }

    emit(AddExpenseLoading());
    OPrint.c('⏳ Emitted AddExpenseLoading. Calling _addExpense use case...');
    OPrint.c('Payload: ${currentState.expense}');

    final res = await _addExpense(currentState.expense);

    res.fold(
      (error) {
        OPrint.r('❌ Add expense failed with error: ${error.message}');
        emit(AddExpenseFailure(message: error.message));
      },
      (_) {
        OPrint.g('✅ Add expense succeeded. Emitting AddExpenseSuccess.');
        emit(AddExpenseSuccess());
      },
    );
  }
}
