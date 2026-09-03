import 'package:shagaf_ledger/core/common/functions/try_db.dart';
import 'package:sqflite/sqflite.dart';

class ClientsDatabase {
  final Database _database;
  static const String clientsTable = "clients";
  static const String clientInterestedProductsTable =
      "client_interested_products";

  ClientsDatabase({required this._database});

  Future<List<Map<String, dynamic>>> getClients() async =>
      await tryDB<List<Map<String, dynamic>>>(
        () async => await _database.query(clientsTable),
      );

  Future<void> addClient({
    required DatabaseExecutor executor,
    required Map<String, dynamic> clientMap,
  }) async => tryDB<void>(() async {
    await executor.insert(clientsTable, clientMap);
  });

  Future<Map<String, dynamic>> getClientDetails({
    required int clientId,
  }) async => await tryDB<Map<String, dynamic>>(() async {
    final res = await _database.query(
      clientsTable,
      where: 'id = ?',
      whereArgs: [clientId],
    );

    return res.first;
  });
}
