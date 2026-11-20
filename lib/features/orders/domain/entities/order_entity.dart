class OrderEntity {
  final int id;
  final double totalPrice;
  final double originalPrice;
  final String createdAt;
  final String note; // optional
  final DiscountType discountType;
  final double discountValue;
  final OrderStatus status;
  final int? clientId;

  OrderEntity({
    required this.id,
    required this.createdAt,
    required this.totalPrice,
    required this.originalPrice,
    this.note = "",
    required this.discountType,
    required this.discountValue,
    this.status = OrderStatus.completed,
    this.clientId,
  });

  OrderEntity copyWith({
    int? id,
    double? totalPrice,
    double? originalPrice,
    String? createdAt,
    String? note,
    DiscountType? discountType,
    double? discountValue,
    OrderStatus? status,
    int? clientId,
  }) {
    return OrderEntity(
      id: id ?? this.id,
      totalPrice: totalPrice ?? this.totalPrice,
      originalPrice: originalPrice ?? this.originalPrice,
      createdAt: createdAt ?? this.createdAt,
      note: note ?? this.note,
      discountType: discountType ?? this.discountType,
      discountValue: discountValue ?? this.discountValue,
      status: status ?? this.status,
      clientId: clientId ?? this.clientId,
    );
  }
}

enum DiscountType { amount, percentage }

enum OrderStatus { completed, canceled }
