import 'package:fpdart/fpdart.dart';
import 'package:shagaf_ledger/core/common/errors/failure.dart';
import 'package:shagaf_ledger/features/daily_expenses/domain/entities/expense.dart';

abstract interface class ExpensesRepo {
  Future<Either<Failure, List<Expense>>> getExpenses();

  Future<Either<Failure, void>> addExpense({required Expense expense});
}
