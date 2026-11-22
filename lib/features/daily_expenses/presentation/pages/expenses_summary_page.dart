import 'dart:ui';

import 'package:animated_segmented_tab_control_plus/animated_segmented_tab_control_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shagaf_ledger/core/app_navigator/app_navigator.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/core/common/errors/UI/error_page.dart';
import 'package:shagaf_ledger/core/common/pages/loading_page.dart';
import 'package:shagaf_ledger/core/common/widgets/custom_app_bar.dart';
import 'package:shagaf_ledger/core/common/widgets/custom_fab.dart';
import 'package:shagaf_ledger/features/daily_expenses/presentation/state_management/expenses/expenses_cubit.dart';

class ExpensesSummaryPage extends StatelessWidget {
  const ExpensesSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<ExpensesCubit, ExpensesState>(
      builder: (context, state) {
        if (state is ExpensesLoading) {
          return LoadingPage();
        }

        if (state is ExpensesLoaded) {
          return Scaffold(
            appBar: CustomAppBar(
              title: const Text(
                'Expenses',
                // TODO: make this the default look for the app bar title
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),

            body: ListView(
              children: [
                //  marketing
                Card(),
                //   transport
                Card(),
                //  rent
                Card(),
                //  other
                Card(),
              ],
            ),

            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 100.0),
              child: CustomFab(
                onPressed: () async {
                  // TODO: NAVIGATE TO ADD EXPENSE SHEET PAGE
                  final newExpenseId = await AppNavigator()
                      .navToAddExpenseSheet(context);

                  if (newExpenseId is int) {
                    OPrint.lineBg('');
                    OPrint.lineBg('');
                    OPrint.lineBg('');
                    OPrint.lineBg('');
                    OPrint.lineBg('');
                    OPrint.lineBg('NEW EXPENSE WAS ADDED, ID: $newExpenseId');
                    OPrint.lineBg('');
                    OPrint.lineBg('');
                    OPrint.lineBg('');
                    OPrint.lineBg('');
                    OPrint.lineBg('');
                  }
                },
                child: Icon(
                  Icons.add_rounded,
                  weight: 30,
                  color: colorScheme.primary,
                ),
              ),
            ),
          );
        }

        return ErrorPage();
      },
    );
  }
}
