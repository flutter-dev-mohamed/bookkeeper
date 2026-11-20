import 'package:fpdart/src/either.dart';
import 'package:shagaf_ledger/core/common/errors/failure.dart';
import 'package:shagaf_ledger/core/common/use_cases/use_cases.dart';
import 'package:shagaf_ledger/features/daily_expenses/domain/entities/expense.dart';
import 'package:shagaf_ledger/features/daily_expenses/domain/repository/expenses_repo.dart';

class DeleteExpense implements UseCases<bool, Expense> {
  final ExpensesRepo _expensesRepo;

  DeleteExpense({required this._expensesRepo});

  @override
  Future<Either<Failure, bool>> call(Expense expense) async =>
      await _expensesRepo.deleteExpense(expense: expense);
}
