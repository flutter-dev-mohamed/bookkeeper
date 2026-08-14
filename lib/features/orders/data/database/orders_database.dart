import 'package:shagaf_ledger/core/common/errors/database_exception.dart';
import 'package:shagaf_ledger/core/common/errors/unknown_exception.dart';
import 'package:shagaf_ledger/core/common/functions/try_db.dart';
import 'package:shagaf_ledger/features/orders/data/models/order_entity_model.dart';
import 'package:sqflite/sqflite.dart';

class OrdersDatabase {
  final Database localDB;
  static const String ordersTable = 'orders';

  OrdersDatabase({required this.localDB});

  //  ——————————————————————————————————————————————————————————————————————————  getOrders: load orders filtered by date
  Future<List<Map<String, dynamic>>> getOrders({required String date}) async {
    return await tryDB<List<Map<String, dynamic>>>(() async {
      final res = await localDB.query(
        ordersTable,
        where: 'created_at = ? ',
        whereArgs: [date],
      );
      return res;
    });
  }

  //  ——————————————————————————————————————————————————————————————————————————  createOrder: inserts a new order into DB
  Future<int> createOrder({
    required Map<String, dynamic> orderMap,
    DatabaseExecutor? executor,
  }) async {
    final db = executor ?? localDB;
    return await tryDB<int>(() async => await db.insert(ordersTable, orderMap));
  }
}
