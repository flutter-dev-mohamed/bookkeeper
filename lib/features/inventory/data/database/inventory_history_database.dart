import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/core/common/functions/try_db.dart';
import 'package:sqflite/sqflite.dart';

class InventoryHistoryDatabase {
  final Database _database;
  static const String inventoryAdditionsTable = "inventory_additions";

  InventoryHistoryDatabase({required this._database});

  Future<List<Map<String, dynamic>>> getInventoryAdditions() async =>
      tryDB(() async => await _database.query(inventoryAdditionsTable));

  Future<List<Map<String, dynamic>>> getProductAdditions({
    required int productId,
  }) async => tryDB(
    () async => await _database.query(
      inventoryAdditionsTable,
      where: 'product_id =?',
      whereArgs: [productId],
    ),
  );

  Future<void> addInventoryAddition({
    required Map<String, dynamic> additionMap,
    required DatabaseExecutor executor,
  }) async => tryDB<void>(() async {
    final res = await executor.insert(inventoryAdditionsTable, additionMap);
    OPrint.g('Inventory Addition Added Successfully');
  });

  Future<void> addInitialInventory({
    required DatabaseExecutor executor,
    required int productId,
    required String productName,
    required int quantity,
    required double unitPurchasePrice,
    required double unitSellingPrice,
    required double addedCost,
    required String note,
    required String createdAt,
  }) async => tryDB<void>(() async {
    final additionMap = {
      'product_id': productId,
      'product_name': productName,
      'quantity': quantity,
      'purchase_price': unitPurchasePrice,
      'unit_selling_price': unitSellingPrice,
      'total_cost': unitPurchasePrice * quantity,
      'added_cost': addedCost,
      'note': note,
      'created_at': createdAt,
    };

    final res = await executor.insert(inventoryAdditionsTable, additionMap);
    OPrint.g('Inventory Addition Added Successfully');
  });
}
