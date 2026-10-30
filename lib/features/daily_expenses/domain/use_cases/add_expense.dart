import 'package:fpdart/src/either.dart';
import 'package:shagaf_ledger/core/common/errors/failure.dart';
import 'package:shagaf_ledger/core/common/use_cases/use_cases.dart';
import 'package:shagaf_ledger/features/daily_expenses/domain/entities/expense.dart';
import 'package:shagaf_ledger/features/daily_expenses/domain/repository/expenses_repo.dart';

class AddExpense implements UseCases<void, Expense> {
  final ExpensesRepo expensesRepo;

  AddExpense({required this.expensesRepo});

  @override
  Future<Either<Failure, void>> call(Expense expense) async =>
      await expensesRepo.addExpense(expense: expense);
}
