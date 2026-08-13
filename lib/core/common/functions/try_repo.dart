import 'package:fpdart/fpdart.dart';
import 'package:shagaf_ledger/core/common/errors/database_exception.dart';
import 'package:shagaf_ledger/core/common/errors/failure.dart';

Future<Either<Failure, T>> tryRepo<T>(Future<T> Function() action) async {
  try {
    return right(await action());
  } on LocalDatabaseException catch (e) {
    return left(Failure(message: e.message));
  } catch (e) {
    return left(Failure(message: e.toString()));
  }
}
