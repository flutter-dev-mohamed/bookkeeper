import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/features/orders/domain/entities/order_entity.dart';

class OrderEntityModel extends OrderEntity {
  OrderEntityModel({
    required super.id,
    required super.createdAt,
    required super.totalPrice,
    required super.originalPrice,
    required super.note,
    required super.discountType,
    required super.discountValue,
    super.status,
  });

  Map<String, dynamic> toMap() {
    final map = {
      'total_price': totalPrice,
      'original_price': originalPrice,
      'created_at': createdAt,
      'note': note,
      'discount_type': discountType.index,
      'discount_value': discountValue,
      'status': status.index,
    };
    OPrint.line('toMap Order Entity');
    OPrint.c('Mapping order toMap: $map');
    OPrint.line('toMap Order Entity');
    return map;
  }

  factory OrderEntityModel.fromMap({required Map<String, dynamic> map}) {
    OPrint.y(map);
    return OrderEntityModel(
      id: map['id'] as int,
      totalPrice: map['total_price'],
      originalPrice: map['original_price'],
      createdAt: map['created_at'],
      note: map['note'] as String? ?? '',
      discountType: DiscountType.values[map['discount_type'] as int],
      discountValue: map['discount_value'],
      status: OrderStatus.values[map['status'] as int],
    );
  }

  factory OrderEntityModel.fromOrderEntity(OrderEntity entity) {
    return OrderEntityModel(
      id: entity.id,
      createdAt: entity.createdAt,
      totalPrice: entity.totalPrice,
      originalPrice: entity.originalPrice,
      note: entity.note,
      discountType: entity.discountType,
      discountValue: entity.discountValue,
      status: entity.status,
    );
  }
}
