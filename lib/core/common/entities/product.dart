class Product {
  int id;
  String name;
  String? note;
  double sellingPrice;
  double purchasePrice;
  int currentInventory;
  DateTime createdAt;
  bool isArchived;

  Product({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.currentInventory,
    required this.purchasePrice,
    required this.sellingPrice,
    this.note = "",
    this.isArchived = false,
  });

  @override
  String toString() {
    // TODO: implement toString
    return 'Product: '
        'id: $id, '
        'name: "$name", '
        'isArchived: $isArchived, '
        'note: "$note"'
        'currentInventory: $currentInventory, '
        'purchasePrice: $purchasePrice, '
        'sellingPrice: $sellingPrice';
  }
}
