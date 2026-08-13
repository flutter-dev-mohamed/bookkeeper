import 'package:shagaf_ledger/features/orders/domain/entities/order_item.dart';

class OrderEntity {
  int id;
  double totalPrice;
  String createdAt;
  String note; // optional

  OrderEntity({
    required this.id,
    required this.createdAt,
    required this.totalPrice,
    this.note = "",
  });
}
