import 'package:shagaf_ledger/features/orders/domain/entities/order_item.dart';

class OrderItemModel extends OrderItem {
  OrderItemModel({
    required super.id,
    required super.orderId,
    required super.productId,
    required super.productName,
    required super.quantity,
    required super.unitSellingPrice,
  });

  factory OrderItemModel.fromEntity(OrderItem entity) {
    return OrderItemModel(
      id: entity.id,
      orderId: entity.orderId,
      productId: entity.productId,
      productName: entity.productName,
      quantity: entity.quantity,
      unitSellingPrice: entity.unitSellingPrice,
    );
  }

  Map<String, dynamic> toMap({required int orderId}) {
    return {
      'order_id': orderId,
      'product_id': productId,
      'product_name': productName,
      'quantity': quantity,
      'unit_selling_price': unitSellingPrice,
      'total_price': totalPrice,
    };
  }

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      id: map['id'] as int,
      orderId: map['order_id'] as int,
      productId: map['product_id'] as int,
      productName: map['product_name'] as String,
      quantity: map['quantity'] as int,
      unitSellingPrice: (map['unit_selling_price'] as num).toDouble(),
    );
  }
}
