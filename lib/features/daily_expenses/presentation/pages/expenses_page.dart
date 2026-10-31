import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shagaf_ledger/core/app_navigator/app_navigator.dart';
import 'package:shagaf_ledger/core/common/errors/UI/error_page.dart';
import 'package:shagaf_ledger/core/common/pages/loading_page.dart';
import 'package:shagaf_ledger/core/common/widgets/custom_fab.dart';
import 'package:shagaf_ledger/features/daily_expenses/domain/entities/expense.dart';
import 'package:shagaf_ledger/features/daily_expenses/presentation/state_management/expenses/expenses_cubit.dart';
import 'package:shagaf_ledger/features/daily_expenses/presentation/widgets/expense_tile.dart';

class ExpensesPage extends StatelessWidget {
  const ExpensesPage({super.key});

  void onEdit(BuildContext context, Expense newExpense, int index) {
    context.read<ExpensesCubit>().editExpense(newExpense, index);
  }

  void onDelete(BuildContext context, int expenseIndex) {
    context.read<ExpensesCubit>().deleteExpense(expenseIndex);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpensesCubit, ExpensesState>(
      builder: (context, state) {
        //  ————————————————————————————————————————————————————————————————————  Loading page
        if (state is ExpensesLoading) return LoadingPage();

        //  ————————————————————————————————————————————————————————————————————  page UI
        if (state is ExpensesLoaded) {
          final List<Expense> expenses = state.expenses;

          return Directionality(
            textDirection: TextDirection.ltr,
            child: Scaffold(
              //
              body: SafeArea(
                bottom: false,

                child: ListView.builder(
                  //
                  shrinkWrap: true,
                  itemCount: expenses.length + 1,
                  itemBuilder: (context, index) {
                    if (index == expenses.length) return SizedBox(height: 100);

                    return Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                      child: ExpenseTile(
                        expense: expenses[index],
                        onEdit: (newExpense) =>
                            onEdit(context, newExpense, index),
                        onDelete: () => onDelete(context, index),
                      ),
                    );
                  },
                ),
              ),

              floatingActionButtonLocation:
                  FloatingActionButtonLocation.miniStartFloat,
              floatingActionButton: Padding(
                padding: const EdgeInsets.only(bottom: 110.0),
                child: CustomFab(
                  onPressed: () async {
                    final addedExpense = await AppNavigator()
                        .navToAddExpensePage(context);

                    if (addedExpense != null && context.mounted) {
                      // TODO: update page on change
                      context.read<ExpensesCubit>().addExpenseToStateList(
                        addedExpense,
                      );
                    }
                  },
                  child: Image.asset(
                    'lib/core/assets/icons/expense_filled.png',
                    color: Theme.of(context).colorScheme.primary,
                    width: 30,
                  ),
                ),
              ),
            ),
          );
        }

        //  ————————————————————————————————————————————————————————————————————  error page
        return ErrorPage();
      },
    );
  }
}
