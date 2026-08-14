import 'package:shagaf_ledger/features/orders/domain/entities/order_entity.dart';

class OrderEntityModel extends OrderEntity {
  OrderEntityModel({
    required super.id,
    required super.createdAt,
    required super.totalPrice,
    required super.note,
    required super.discountType,
    required super.discountValue,
  });

  Map<String, dynamic> toMap() {
    return {
      'total_price': totalPrice,
      'created_at': createdAt, // .toIso8601String()
      'note': note,
      'discount_type': discountType.index,
      'discount_value': discountValue,
    };
  }

  factory OrderEntityModel.fromMap({required Map<String, dynamic> map}) {
    return OrderEntityModel(
      id: map['id'] as int,
      totalPrice: (map['total_price'] as num).toDouble(),
      createdAt: map['created_at'],
      note: map['note'] as String? ?? '',
      discountType: DiscountType.values[map['discount_type'] as int],
      discountValue: map['discount_value'],
    );
  }

  factory OrderEntityModel.fromOrderEntity(OrderEntity entity) {
    return OrderEntityModel(
      id: entity.id,
      createdAt: entity.createdAt,
      totalPrice: entity.totalPrice,
      note: entity.note,
      discountType: entity.discountType,
      discountValue: entity.discountValue,
    );
  }
}
