class OrderItem {
  final int id;
  final int orderId;
  final int productId;
  final String productName;
  final int quantity;
  final double unitSellingPrice;
  final double totalPrice;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitSellingPrice,
  }) : totalPrice = quantity * unitSellingPrice;

  OrderItem copyWith({
    int? id,
    int? orderId,
    int? productId,
    String? productName,
    int? quantity,
    double? unitSellingPrice,
  }) {
    return OrderItem(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      unitSellingPrice: unitSellingPrice ?? this.unitSellingPrice,
    );
  }
}
