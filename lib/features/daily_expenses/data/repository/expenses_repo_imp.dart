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
  Future<Either<Failure, List<Expense>>> getExpenses() async =>
      tryRepo<List<ExpenseModel>>(() async {
        final expensesMapList = await _expensesDatabase.getAllExpenses();
        final expensesList = expensesMapList
            .map((expenseMap) => ExpenseModel.fromMap(expenseMap))
            .toList();

        return expensesList;
      });

  @override
  Future<Either<Failure, void>> addExpense({required Expense expense}) async =>
      tryRepo<void>(() async {
        final expenseModel = ExpenseModel.fromEntity(expense);

        return _expensesDatabase.insetExpense(expenseMap: expenseModel.toMap());
      });

  @override
  Future<Either<Failure, bool>> deleteExpense({
    required Expense expense,
  }) async => await tryRepo<bool>(() async {
    final expenseModel = ExpenseModel.fromEntity(expense);

    final resId = await _expensesDatabase.deleteExpense(
      id: expenseModel.id,
      expenseMap: expenseModel.toMap(),
    );

    return resId == expenseModel.id;
  });
}
