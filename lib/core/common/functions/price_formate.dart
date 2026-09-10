import 'package:intl/intl.dart';
import 'package:shagaf_ledger/core/common/colored_prints.dart';

String priceFormate(double price) {
  var format = NumberFormat.currency(
    locale: 'ar_IQ',
    symbol: 'IQD',
    decimalDigits: price % 1 == 0 ? 0 : 2,
    customPattern: '\u00A4 #,##0',
  );

  return format.format(price);
}
