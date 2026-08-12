import 'package:shagaf_ledger/features/orders/domain/entities/order_item.dart';

class Order {
  int id;
  double totalPrice;
  DateTime createdAt;
  List<OrderItem> items;
  String note; // optional

  Order({
    required this.id,
    required this.createdAt,
    required this.totalPrice,
    required this.items,
    this.note = "",
  });
}
