import 'package:shagaf_ledger/core/common/colored_prints.dart';

class LocalDatabaseException implements Exception {
  String message;

  LocalDatabaseException({required this.message}) {
    // TODO: remove print
    OPrint.br("\nLocalDatabaseException: $message");
  }
}
