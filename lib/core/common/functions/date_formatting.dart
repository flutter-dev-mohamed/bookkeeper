import 'package:intl/intl.dart';

String dateFormatting(DateTime date) {
  final format = DateFormat('yyyy-M-d', 'ar_IQ');

  return format.format(date);
}
