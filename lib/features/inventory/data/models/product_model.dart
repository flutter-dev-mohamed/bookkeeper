import 'package:shagaf_ledger/features/inventory/domain/entities/product.dart';

class ProductModel extends Product {
  ProductModel({
    required super.id,
    required super.name,
    required super.createdAt,
    required super.currentInventory,
    required super.purchasePrice,
    required super.sellingPrice,
    super.note = '',
  });

  // id INTEGER PRIMARY KEY,
  // name TEXT,
  // note TEXT,
  // selling_price REAL,
  // purchase_price REAL,
  // current_inventory INTEGER,
  // created_at TEXT
  // toIso8601String()

  Map<String, dynamic> toMap({bool update = false}) {
    return {
      "name": name,
      "note": note,
      "selling_price": sellingPrice,
      "purchase_price": purchasePrice,
      "current_inventory": currentInventory,
      // don't add the created_at in when updating
      if (!update) "created_at": createdAt.toIso8601String(),
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> productMap) {
    return ProductModel(
      id: productMap['id'],
      name: productMap['name'],
      note: productMap['note'],
      sellingPrice: productMap['selling_price'],
      purchasePrice: productMap['purchase_price'],
      currentInventory: productMap['current_inventory'],
      createdAt: DateTime.parse(productMap['created_at']),
    );
  }

  // from Product to ProductModel
  factory ProductModel.fromProduct(Product product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      note: product.note,
      createdAt: product.createdAt,
      currentInventory: product.currentInventory,
      purchasePrice: product.purchasePrice,
      sellingPrice: product.sellingPrice,
    );
  }

  @override
  String toString() {
    return 'ProductModel('
        'id: $id, '
        'name: "$name", '
        'note: "$note"'
        'currentInventory: $currentInventory, '
        'purchasePrice: $purchasePrice, '
        'sellingPrice: $sellingPrice'
        ')';
  }
}
