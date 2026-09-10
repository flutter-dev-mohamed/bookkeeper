import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:shagaf_ledger/core/common/errors/database_exception.dart';
import 'package:shagaf_ledger/core/common/errors/unknown_exception.dart';
import 'package:shagaf_ledger/core/common/functions/try_db.dart';
import 'package:shagaf_ledger/features/orders/data/models/order_entity_model.dart';
import 'package:sqflite/sqflite.dart';

class OrdersDatabase {
  final Database _localDB;
  static const String ordersTable = 'orders';

  OrdersDatabase({required this._localDB});

  //  ——————————————————————————————————————————————————————————————————————————  getOrders: load orders filtered by date
  Future<List<Map<String, dynamic>>> getOrders({required String date}) async =>
      await tryDB<List<Map<String, dynamic>>>(() async {
        final res = await _localDB.query(
          ordersTable,
          where: 'created_at = ? ',
          whereArgs: [date],
        );
        return res;
      });

  //  ——————————————————————————————————————————————————————————————————————————  createOrder: inserts a new order into DB
  Future<int> createOrder({
    required Map<String, dynamic> orderMap,
    DatabaseExecutor? executor,
  }) async {
    final db = executor ?? _localDB;
    return await tryDB<int>(() async => await db.insert(ordersTable, orderMap));
  }

  //  ——————————————————————————————————————————————————————————————————————————  getOrder: read (ONLY) the order info from DB
  Future<Map<String, dynamic>> getOrder({required int orderId}) async =>
      await tryDB<Map<String, dynamic>>(() async {
        final res = await _localDB.query(
          ordersTable,
          where: "id = ?",
          whereArgs: [orderId],
        );
        final orderMap = res.first;
        return orderMap;
      });

  //  ——————————————————————————————————————————————————————————————————————————  cancel Order
  Future<void> cancelOrder({
    required int orderId,
    required int statusNo,
    required DatabaseExecutor executor,
  }) async {
    await tryDB<void>(() async {
      final res = await executor.update(
        ordersTable,
        {"status": statusNo},
        where: 'id = ?',
        whereArgs: [orderId],
      );
    });
  }
}
