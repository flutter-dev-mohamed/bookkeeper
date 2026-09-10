class InventoryAddition {
  final int id;
  final int productId;
  final String productName;
  final int quantity;
  final double unitPurchasePrice;
  final double unitSellingPrice;
  final double totalPrice;
  final double addedCost;
  final String note;
  final String createdAt;

  InventoryAddition({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.unitPurchasePrice,
    required this.unitSellingPrice,
    this.note = '',
    required this.createdAt,
    required this.addedCost,
    required this.productName,
  }) : totalPrice = (quantity * unitPurchasePrice) + addedCost;
}
