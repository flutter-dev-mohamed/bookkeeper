import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:sqflite/sqflite.dart';

Future<void> createTables(Database db) async {
  OPrint.bb('=========== Creating db tables ===========');
  await db.execute('''
      CREATE TABLE products (
      id INTEGER PRIMARY KEY,
      name TEXT NOT NULL,
      note TEXT,
      selling_price REAL,
      purchase_price REAL,
      current_inventory INTEGER,
      created_at TEXT
      )''');

  // create the orders table
  await db.execute('''
  CREATE TABLE orders (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    created_at TEXT NOT NULL DEFAULT (DATETIME('now')),
    total_price REAL NOT NULL,
    original_price REAL NOT NULL,
    discount_type INTEGER NOT NULL,
    discount_value REAL NOT NULL,
    note TEXT
  )''');

  // create the order_item table
  await db.execute('''
  CREATE TABLE order_item (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    product_name TEXT NOT NULL,
    quantity INTEGER NOT NULL,
    unit_selling_price REAL NOT NULL,
    total_price REAL NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders (id) ON DELETE CASCADE
  )''');
  //      FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE RESTRICT

  OPrint.g('===========———————— db tables created ————————===========');
}
