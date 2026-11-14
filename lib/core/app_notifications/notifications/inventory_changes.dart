final class InventoryChanges {
  final List<InventoryChange> inventoryChanges;

  const InventoryChanges({required this.inventoryChanges});
}

final class InventoryChange {
  final int productId;
  final int quantity;
  final InventoryChangeType changeType;

  const InventoryChange({
    required this.productId,
    required this.quantity,
    required this.changeType,
  });
}

enum InventoryChangeType { addition, subtract }
