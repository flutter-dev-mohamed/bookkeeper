import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/core/common/functions/try_db.dart';
import 'package:sqflite/sqflite.dart';

class ExpensesDatabase {
  final Database _database;
  final String _expensesTable = "expenses";

  ExpensesDatabase({required this._database});

  // get all expenses

  // add an expense
  Future<void> insetExpense({required Map<String, dynamic> expenseMap}) async {
    OPrint.lineC('DB INSERT EXPENSE');
    OPrint.c('Expense Data: $expenseMap');

    try {
      await tryDB<void>(
        () async => _database.insert(_expensesTable, expenseMap),
      );
      OPrint.g('✅ Expense inserted successfully.');
    } catch (e, stackTrace) {
      OPrint.r('❌ Failed to insert expense: $e');
      OPrint.r(stackTrace.toString());
      rethrow;
    }
  }
}
