class Product {
  int id;
  String name;
  String? note;
  double sellingPrice;
  double purchasePrice;
  int currentInventory;
  DateTime createdAt;

  Product({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.currentInventory,
    required this.purchasePrice,
    required this.sellingPrice,
    this.note = "",
  });
}
