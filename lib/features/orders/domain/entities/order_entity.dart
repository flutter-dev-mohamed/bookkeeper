class OrderEntity {
  final int id;
  final double totalPrice;
  final double originalPrice;
  final String createdAt;
  final String note; // optional
  final DiscountType discountType;
  final double discountValue;
  final OrderStatus status;

  OrderEntity({
    required this.id,
    required this.createdAt,
    required this.totalPrice,
    required this.originalPrice,
    this.note = "",
    required this.discountType,
    required this.discountValue,
    this.status = OrderStatus.completed,
  });
}

enum DiscountType { amount, percentage }

enum OrderStatus { completed, canceled }
