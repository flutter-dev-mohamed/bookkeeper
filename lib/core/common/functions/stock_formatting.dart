import 'package:intl/intl.dart';

String stockFormatting(int stock) {
  final format = NumberFormat('#,###', 'ar_IQ');

  return format.format(stock);
}
