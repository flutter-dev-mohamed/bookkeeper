import 'package:shagaf_ledger/core/common/colored_prints.dart';
import 'package:sqflite/sqflite.dart';

Future<void> createTables(Database db) async {
  OPrint.bb('=========== Creating db tables ===========');
  await db.execute('''
      CREATE TABLE products (
      id INTEGER PRIMARY KEY,
      name TEXT NOT NULL,
      is_archived INTEGER,
      note TEXT,
      selling_price REAL,
      purchase_price REAL,
      current_inventory INTEGER NOT NULL CHECK (current_inventory >= 0),
      created_at TEXT
      )''');

  // create the orders table
  await db.execute('''
  CREATE TABLE orders (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    created_at TEXT NOT NULL DEFAULT (DATETIME('now')),
    client_id INTEGER,
    total_price REAL NOT NULL,
    original_price REAL NOT NULL,
    discount_type INTEGER NOT NULL,
    discount_value REAL NOT NULL,
    status INTEGER NOT NULL,
    note TEXT,
    
    FOREIGN KEY (client_id)
        REFERENCES clients(id)
        ON DELETE SET NULL
  )''');

  // create the order_item table
  await db.execute('''
  CREATE TABLE order_item (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    product_name TEXT NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity >= 1),
    unit_selling_price REAL NOT NULL,
    total_price REAL NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders (id) ON DELETE CASCADE
  )''');
  //      FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE RESTRICT

  await db.execute('''
  CREATE TABLE inventory_additions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity >= 1),
    purchase_price REAL NOT NULL,
    unit_selling_price REAL NOT NULL,
    total_cost REAL NOT NULL,
    note TEXT,
    created_at TEXT NOT NULL
  )''');

  await db.execute('''
  CREATE TABLE clients (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    phone_number TEXT,
    whatsApp TEXT,
    instagram TEXT,
    created_at TEXT NOT NULL DEFAULT (DATETIME('now'))
  )''');

  await db.execute('''
  CREATE TABLE client_interested_products (
    client_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,

    PRIMARY KEY (client_id, product_id),

    FOREIGN KEY (client_id)
        REFERENCES clients(id)
        ON DELETE CASCADE,

    FOREIGN KEY (product_id)
        REFERENCES products(id)
        ON DELETE CASCADE
  )''');

  OPrint.g('===========———————— db tables created ————————===========');
}
