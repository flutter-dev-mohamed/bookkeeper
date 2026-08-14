import 'package:shagaf_ledger/core/common/functions/try_db.dart';
import 'package:sqflite/sqflite.dart';

class OrderItemsDatabase {
  final Database localDB;
  static const String orderItemsTable = 'order_item';

  OrderItemsDatabase({required this.localDB});

  //  ——————————————————————————————————————————————————————————————————————————  getOrderItems: load order items filtered by orderId
  Future<List<Map<String, dynamic>>> getOrderItems({
    required int orderId,
  }) async {
    return await tryDB<List<Map<String, dynamic>>>(() async {
      final res = await localDB.query(
        orderItemsTable,
        where: 'order_id = ? ',
        whereArgs: [orderId],
      );
      return res;
    });
  }

  //  ——————————————————————————————————————————————————————————————————————————  insertOrderItems: inserts items into DB
  Future<void> insertOrderItem({
    required Map<String, dynamic> orderMap,
    DatabaseExecutor? executor,
  }) async {
    final db = executor ?? localDB;

    await tryDB(() async => await db.insert(orderItemsTable, orderMap));
  }
}
