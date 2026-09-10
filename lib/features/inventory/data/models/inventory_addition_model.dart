import 'package:shagaf_ledger/features/inventory/domain/entities/inventory_addition.dart';

class InventoryAdditionModel extends InventoryAddition {
  InventoryAdditionModel({
    required super.id,
    required super.productId,
    required super.productName,
    required super.quantity,
    required super.unitPurchasePrice,
    required super.unitSellingPrice,
    required super.addedCost,
    super.note,
    required super.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'product_id': productId,
      'product_name': productName,
      'quantity': quantity,
      'purchase_price': unitPurchasePrice,
      'unit_selling_price': unitSellingPrice,
      'total_cost': totalPrice,
      'added_cost': addedCost,
      'note': note,
      'created_at': createdAt,
    };
  }

  factory InventoryAdditionModel.fromMap(Map<String, dynamic> map) {
    return InventoryAdditionModel(
      id: map['id'] as int,
      productId: map['product_id'] as int,
      quantity: map['quantity'] as int,
      productName: map['product_name'],
      unitPurchasePrice: (map['purchase_price'] as num).toDouble(),
      unitSellingPrice: (map['unit_selling_price'] as num).toDouble(),
      addedCost: map['added_cost'],
      note: map['note'] as String? ?? '',
      createdAt: map['created_at'] as String,
    );
  }

  factory InventoryAdditionModel.fromEntity(InventoryAddition entity) {
    return InventoryAdditionModel(
      id: entity.id,
      productId: entity.productId,
      productName: entity.productName,
      quantity: entity.quantity,
      unitPurchasePrice: entity.unitPurchasePrice,
      unitSellingPrice: entity.unitSellingPrice,
      addedCost: entity.addedCost,
      note: entity.note,
      createdAt: entity.createdAt,
    );
  }
}
