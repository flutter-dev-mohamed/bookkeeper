import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shagaf_ledger/core/app_navigator/app_navigator.dart';
import 'package:shagaf_ledger/core/common/widgets/custom_fab.dart';
import 'package:shagaf_ledger/features/daily_expenses/presentation/pages/add_expense_page.dart';

class ExpensesPage extends StatelessWidget {
  const ExpensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //
      body: Center(child: Text('data')),

      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 110.0),
        child: CustomFab(
          onPressed: () async {
            final didChange = await AppNavigator().navToAddExpensePage(context);

            if (didChange == true && context.mounted) {
              // update page on change
            }
          },
          child: Image.asset(
            'lib/core/assets/icons/expense_filled.png',
            color: Theme.of(context).colorScheme.primary,
            width: 30,
          ),
        ),
      ),
    );
  }
}
