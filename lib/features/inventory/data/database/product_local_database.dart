import 'package:shagaf_ledger/core/common/functions/try_db.dart';
import 'package:sqflite/sqflite.dart';

class ProductLocalDatabase {
  final Database localDB;
  static const String productsTable = "products";

  ProductLocalDatabase({required this.localDB});

  // getProducts
  Future<List<Map<String, dynamic>>> loadActiveProducts() async {
    return await tryDB<List<Map<String, dynamic>>>(() async {
      final productsMapList = await localDB.query(
        productsTable,
        where: 'is_archived = ?',
        whereArgs: [0],
      );

      return productsMapList;
    });
  }

  // addProduct
  Future<int> addProduct({required Map<String, dynamic> productMap}) async {
    return await tryDB<int>(() async {
      // this returns the raw id or the  new productId
      return await localDB.insert(productsTable, productMap);
    });
  }

  // getProductById
  Future<Map<String, dynamic>> getProductById({required int productId}) async {
    return await tryDB<Map<String, dynamic>>(() async {
      final List<Map<String, dynamic>> result = await localDB.query(
        productsTable,
        where: 'id = ?',
        whereArgs: [productId],
      );

      if (result.isEmpty) {
        throw Exception('Product with ID $productId not found');
      }

      return result.first;
    });
  }

  // updateProduct
  Future<void> updateProduct({
    required int productId,
    required Map<String, dynamic> productMap,
  }) async {
    return await tryDB<void>(() async {
      final noOfUpdatedRows = await localDB.update(
        productsTable,
        productMap,
        where: 'id = ?',
        whereArgs: [productId],
      );
    });
  }

  // Archive Product
  Future<void> archiveProduct({required int productId}) async {
    return await tryDB<void>(() async {
      final res = await localDB.update(
        productsTable,
        {"is_archived": 1},
        where: 'id = ?',
        whereArgs: [productId],
      );
    });
  }

  Future<void> decrementProductInventory({
    required int productId,
    required int quantity,
    required DatabaseExecutor executor,
  }) async {
    return await tryDB(() async {
      final row = await executor.query(
        productsTable,
        where: 'id = ?',
        whereArgs: [productId],
      );

      final currentInventory = row.first['current_inventory'] as int;
      final newInventory = currentInventory - quantity;

      final res = await executor.update(
        productsTable,
        {"current_inventory": newInventory},
        where: 'id = ?',
        whereArgs: [productId],
      );
    });
  }

  Future<void> incrementProductInventory({
    required int productId,
    required int quantity,
    required DatabaseExecutor executor,
  }) async {
    return await tryDB<void>(() async {
      // get the current inventory
      final row = await executor.query(
        productsTable,
        where: 'id = ?',
        whereArgs: [productId],
      );

      final currentInventory = row.first['current_inventory'] as int;
      // add the quantity to current inventory
      final newInventory = currentInventory + quantity;

      // update current inventory
      final res = await executor.update(
        productsTable,
        {"current_inventory": newInventory},
        where: 'id = ?',
        whereArgs: [productId],
      );
    });
  }

  // get Archived Products
  Future<List<Map<String, dynamic>>> loadArchivedProducts() async {
    return await tryDB<List<Map<String, dynamic>>>(() async {
      final productsMapList = await localDB.query(
        productsTable,
        where: 'is_archived = ?',
        whereArgs: [1],
      );

      return productsMapList;
    });
  }

  /// This method takes the Product id and sets the "is_archived" column to (0).
  Future<void> removeProductFromArchive({required int productId}) async {
    return await tryDB<void>(() async {
      final res = await localDB.update(
        productsTable,
        {"is_archived": 0},
        where: 'id = ?',
        whereArgs: [productId],
      );
    });
  }
}
