import 'package:shagaf_ledger/features/orders/domain/entities/order_entity.dart';

class OrderEntityModel extends OrderEntity {
  OrderEntityModel({
    required super.id,
    required super.createdAt,
    required super.totalPrice,
    required super.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'total_price': totalPrice,
      'created_at': createdAt, // .toIso8601String()
      'note': note,
    };
  }

  factory OrderEntityModel.fromMap({required Map<String, dynamic> map}) {
    return OrderEntityModel(
      id: map['id'] as int,
      totalPrice: (map['total_price'] as num).toDouble(),
      createdAt: map['created_at'],
      note: map['note'] as String? ?? '',
    );
  }

  factory OrderEntityModel.fromOrderEntity(OrderEntity entity) {
    return OrderEntityModel(
      id: entity.id,
      createdAt: entity.createdAt,
      totalPrice: entity.totalPrice,
      note: entity.note,
    );
  }
}
