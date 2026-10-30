import 'package:fpdart/src/either.dart';
import 'package:shagaf_ledger/core/common/errors/failure.dart';
import 'package:shagaf_ledger/core/common/functions/try_repo.dart';
import 'package:shagaf_ledger/features/daily_expenses/data/database/expenses_database.dart';
import 'package:shagaf_ledger/features/daily_expenses/data/models/expense_model.dart';
import 'package:shagaf_ledger/features/daily_expenses/domain/entities/expense.dart';
import 'package:shagaf_ledger/features/daily_expenses/domain/repository/expenses_repo.dart';

class ExpensesRepoImp implements ExpensesRepo {
  final ExpensesDatabase _expensesDatabase;

  ExpensesRepoImp({required this._expensesDatabase});

  @override
  Future<Either<Failure, void>> addExpense({required Expense expense}) async =>
      tryRepo<void>(() async {
        final expenseModel = ExpenseModel.fromEntity(expense);

        return _expensesDatabase.insetExpense(expenseMap: expenseModel.toMap());
      });

  @override
  Future<Either<Failure, List<Expense>>> getExpenses() async {
    // TODO: implement getExpenses
    throw UnimplementedError();
  }
}
