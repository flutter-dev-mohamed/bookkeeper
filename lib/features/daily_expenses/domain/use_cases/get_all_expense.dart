import 'package:fpdart/src/either.dart';
import 'package:shagaf_ledger/core/common/errors/failure.dart';
import 'package:shagaf_ledger/core/common/use_cases/use_cases.dart';
import 'package:shagaf_ledger/features/daily_expenses/domain/entities/expense.dart';
import 'package:shagaf_ledger/features/daily_expenses/domain/repository/expenses_repo.dart';

class GetAllExpense implements UseCases<List<Expense>, NoParams> {
  final ExpensesRepo _expensesRepo;

  GetAllExpense({required this._expensesRepo});

  @override
  Future<Either<Failure, List<Expense>>> call(NoParams noParams) async =>
      await _expensesRepo.getExpenses();
}
