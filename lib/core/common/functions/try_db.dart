import 'package:shagaf_ledger/core/common/errors/database_exception.dart';
import 'package:shagaf_ledger/core/common/errors/unknown_exception.dart';
import 'package:sqflite/sqflite.dart';

Future<T> tryDB<T>(Future<T> Function() action) async {
  try {
    return await action();
  } on DatabaseException catch (e) {
    throw LocalDatabaseException(message: e.toString());
  } catch (e) {
    throw UnknownException(message: e.toString());
  }
}
