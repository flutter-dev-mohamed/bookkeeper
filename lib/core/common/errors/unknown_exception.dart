import 'package:shagaf_ledger/core/common/colored_prints.dart';

class UnknownException implements Exception {
  String message;

  UnknownException({required this.message}) {
    // TODO: remove print
    OPrint.br("\nUnknownException: $message");
  }
}
