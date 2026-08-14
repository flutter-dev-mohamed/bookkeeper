class OrderEntity {
  final int id;
  final double totalPrice;
  final String createdAt;
  final String note; // optional
  final DiscountType discountType;
  final double discountValue;

  OrderEntity({
    required this.id,
    required this.createdAt,
    required this.totalPrice,
    this.note = "",
    required this.discountType,
    required this.discountValue,
  });
}

enum DiscountType { amount, percentage }
