import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/core/common/functions/try_db.dart';
import 'package:sqflite/sqflite.dart';

class OrderItemsDatabase {
  final Database _localDB;
  static const String orderItemsTable = 'order_item';

  OrderItemsDatabase({required this._localDB});

  //  ——————————————————————————————————————————————————————————————————————————  getOrderItems: read (ONLY) order items filtered by orderId
  Future<List<Map<String, dynamic>>> getOrderItems({
    required int orderId,
  }) async {
    return await tryDB<List<Map<String, dynamic>>>(() async {
      final res = await _localDB.query(
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
    final db = executor ?? _localDB;

    await tryDB(() async => await db.insert(orderItemsTable, orderMap));
  }
}
