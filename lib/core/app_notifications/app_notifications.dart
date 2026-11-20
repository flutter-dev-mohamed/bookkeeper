import 'dart:async';

import 'package:shagaf_ledger/core/app_notifications/notifications/inventory_changes.dart';

class AppNotifications {
  // ——————————————————————————————————————————————————————————————————————————— inventory notifications
  final _inventoryController = StreamController<InventoryChanges>.broadcast();

  Stream<InventoryChanges> get inventoryChanges => _inventoryController.stream;

  void notifyInventoryChanged(InventoryChanges event) =>
      _inventoryController.add(event);

  Future<void> dispose() => _inventoryController.close();
}
