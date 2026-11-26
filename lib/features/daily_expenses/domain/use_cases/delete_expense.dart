import 'package:fpdart/src/either.dart';
import 'package:shagaf_ledger/core/common/errors/failure.dart';
import 'package:shagaf_ledger/core/common/use_cases/use_cases.dart';
import 'package:shagaf_ledger/features/daily_expenses/domain/entities/expense.dart';
import 'package:shagaf_ledger/features/daily_expenses/domain/repository/expenses_repo.dart';

class DeleteExpense implements UseCases<void, int> {
  final ExpensesRepo _expensesRepo;

  DeleteExpense({required this._expensesRepo});

  @override
  Future<Either<Failure, void>> call(int expenseId) async =>
      await _expensesRepo.deleteExpense(expenseId: expenseId);
}
