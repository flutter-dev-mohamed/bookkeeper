import 'package:path/path.dart';
import 'package:shagaf_ledger/initDependencies/tables.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> initLocalDatabase() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'shagaf_leger.db');

  return await openDatabase(path, version: 1, onCreate: _onCreate);
}

Future<void> _onCreate(Database db, int version) async {
  // create db tables
  await createTables(db);
}
