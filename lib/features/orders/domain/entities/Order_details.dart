import 'package:shagaf_ledger/features/orders/domain/entities/order_entity.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_item.dart';

class OrderDetails {
  final OrderEntity order;
  final List<OrderItem> items;

  OrderDetails({required this.order, required this.items});
}
