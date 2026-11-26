import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shagaf_ledger/core/app_navigator/app_navigator.dart';
import 'package:shagaf_ledger/core/common/errors/UI/error_page.dart';
import 'package:shagaf_ledger/core/common/functions/show_alert_dialogue.dart';
import 'package:shagaf_ledger/core/common/pages/loading_page.dart';
import 'package:shagaf_ledger/core/common/widgets/custom_app_bar.dart';
import 'package:shagaf_ledger/core/common/widgets/custom_fab.dart';
import 'package:shagaf_ledger/features/daily_expenses/domain/entities/expense.dart';
import 'package:shagaf_ledger/features/daily_expenses/presentation/state_management/expenses/expenses_cubit.dart';
import 'package:shagaf_ledger/features/daily_expenses/presentation/state_management/expenses/expenses_effect.dart';
import 'package:shagaf_ledger/features/daily_expenses/presentation/widgets/expense_tile.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  late final StreamSubscription<ExpensesEffect> _effectsSubscription;

  @override
  void initState() {
    super.initState();

    final cubit = context.read<ExpensesCubit>();

    _effectsSubscription = cubit.effects.listen((effect) {
      if (!mounted) return;

      switch (effect) {
        case ShowExpensesErrorDialog():
          showAlertDialogue(context: context, message: effect.message);
      }
    });
  }

  @override
  void dispose() {
    _effectsSubscription.cancel();
    super.dispose();
  }

  void onEdit(BuildContext context, Expense newExpense, int index) {
    context.read<ExpensesCubit>().editExpense(newExpense, index);
  }

  void onDelete(BuildContext context, int expenseIndex) {
    context.read<ExpensesCubit>().deleteExpense(expenseIndex);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
              appBar: CustomAppBar(
                title: Text(
                  'Expenses',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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
            ),
          );
        }

        //  ————————————————————————————————————————————————————————————————————  error page
        return ErrorPage();
      },
    );
  }
}
