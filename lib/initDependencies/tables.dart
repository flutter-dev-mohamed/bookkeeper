import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:sqflite/sqflite.dart';

Future<void> createTables(Database db) async {
  OPrint.bb('=========== Creating db tables ===========');
  await db.execute('''
      CREATE TABLE products (
      id INTEGER PRIMARY KEY,
      name TEXT,
      note TEXT,
      selling_price REAL,
      purchase_price REAL,
      current_inventory INTEGER,
      created_at TEXT
      )''');
  OPrint.bb('=========== db tables created ===========');
}
