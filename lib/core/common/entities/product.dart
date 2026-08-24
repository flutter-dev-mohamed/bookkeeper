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

  Product copyWith({
    int? id,
    String? name,
    String? note,
    bool clearNote = false,
    double? sellingPrice,
    double? purchasePrice,
    int? currentInventory,
    DateTime? createdAt,
    bool? isArchived,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      note: clearNote ? null : (note ?? this.note),
      sellingPrice: sellingPrice ?? this.sellingPrice,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      currentInventory: currentInventory ?? this.currentInventory,
      createdAt: createdAt ?? this.createdAt,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  @override
  String toString() {
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
