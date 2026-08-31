import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart'; // for databaseFactoryFfiWeb
import 'package:path_provider/path_provider.dart';

// ---------- collect global vars ----------
final String TITLE_NAME = "BEST PRICE";
final Text TITLE_TEXT = Text(TITLE_NAME, style: TextStyle(fontSize: 20,));

// ---------- class data ----------

class PackPrice {
  final int id;
  final String name;

  PackPrice({required this.id, required this.name});

  Map<String, Object?> toMap() {
    return {'id': id, 'name': name};
  }
}

class ProductPrice {
  final int id;
  final double price;
  final double piece;
  final double quantity; //per unit
  final String note;

  ProductPrice({required this.id, required this.price, required this.piece, required this.quantity, required this.note});

  Map<String, Object?> toMap() {
    return {'id': id, 'price': price, 'piece': piece, 'quantity': quantity, 'note': note};
  }

  @override
  String toString() {
    return 'Dog{id: $id, price: $price, piece: $piece, quantity: $quantity, note: $note}';
  }
}

class ProductCal {
  final int id;
  final double price;
  final double piece;
  final double quantity; //per unit
  final double calculate;
  final String note;

  ProductCal({required this.id, required this.price, required this.piece, required this.quantity, required this.calculate, required this.note});
}

// ---------- init database ----------

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String pathDb;
    WidgetsFlutterBinding.ensureInitialized();

    if (kIsWeb) {
      databaseFactoryOrNull = databaseFactoryFfiWeb;
      pathDb = 'ProductPrice_database.db'; 

    } else {
      var databasesPath = await getApplicationDocumentsDirectory();
      pathDb = join(databasesPath.path, 'ProductPrice_database.db');
    }

    return await openDatabase(
      pathDb,
      version: 1,
      onCreate: _onCreate,
      // onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE pack_price (
        id INTEGER PRIMARY KEY, 
        name TEXT
      )
      '''
    );

    await db.execute(
      '''
      CREATE TABLE product_price (
        id INTEGER PRIMARY KEY, 
        price REAL,
        piece REAL,
        quantity REAL,
        calculate REAL,
        note TEXT,
        pack_id INT REFERENCES pack_price(id)
      )
      '''
    );

  }

  // Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
  //   if (oldVersion < 3) {
  //     await db.execute('DROP TABLE IF EXISTS product_price');
  //     await _onCreate(db, newVersion);
  //   }
  // }


// ---------- pack_price ----------

  Future<List<PackPrice>> fetchPack() async {
    final db = await database;

    final List<Map<String, Object?>> packMaps = await db.query('pack_price');

    return packMaps.map((row) {
      return PackPrice(
        id: row['id'] as int,
        name: (row['name'] as String?) ?? '',
      );
    }).toList();
  }

  Future<PackPrice?> fetchPackById(int id) async {
    final db = await database;
 
    final List<Map<String, Object?>> packMaps = await db.query(
      'pack_price',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
 
    if (packMaps.isEmpty) return null;
 
    final row = packMaps.first;
    return PackPrice(
      id: row['id'] as int,
      name: (row['name'] as String?) ?? '',
    );
  }

  Future<int> addPack(PackPrice packPrice) async {
    final db = await database;

    return await db.insert("pack_price", {
      "name": packPrice.name
    });
  }

  Future<int> updatePack(PackPrice packPrice) async {
    final db = await database;

    return await db.update(
      'pack_price',
      packPrice.toMap(),
      where: 'id = ?',
      whereArgs: [packPrice.id],
    );
  }

  Future<int> deletePack(int id) async {
    final db = await database;

    return await db.delete(
      'pack_price',
      where: 'id = ?',
      whereArgs: [id],
    );
  }


// ---------- product_price ----------

  Future<List<ProductPrice>> fetchPrice(int pack_id) async {
    final db = await database;

    final List<Map<String, Object?>> priceMaps = await db.query(
      'product_price',
      columns: ['id', 'price', 'piece', 'quantity', 'note'],
      where: 'pack_id = ?',
      whereArgs: [pack_id],
      );

    return priceMaps.map((row) {
      return ProductPrice(
        id: row['id'] as int,
        price: (row['price'] as num).toDouble(),
        piece: (row['piece'] as num).toDouble(),
        quantity: (row['quantity'] as num).toDouble(),
        note: (row['note'] as String?) ?? '',
      );
    }).toList();
  }

  Future<List<ProductCal>> calculatePrice(int pack_id) async {
    final db = await database;
    List<ProductCal> item = [];
    double calVal;

    final List<Map<String, Object?>> priceMaps = await db.query(
      'product_price',
      columns: ['id', 'price', 'piece', 'quantity', 'note'],
      where: 'pack_id = ?',
      whereArgs: [pack_id],
      );

    for (final row in priceMaps) {
      final id = row['id'] as int;
      final price = (row['price'] as num).toDouble();
      final piece = (row['piece'] as num).toDouble();
      final quantity = (row['quantity'] as num).toDouble();
      final note = (row['note'] as String?) ?? '';

      calVal = double.parse((price / (piece * quantity)).toStringAsFixed(2));
      item.add(ProductCal(id: id, price: price, piece: piece, quantity: quantity, calculate: calVal, note: note));
      _updateCalculate(id, calVal);
    }

    return item;
  }

  Future<int> _updateCalculate(int id, double calValue) async {
    final db = await database;

    return await db.update(
      'product_price',
      {'calculate': calValue},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<double>> bestPrice(int pack_id) async {
    final db = await database;

    final List<Map<String, dynamic>> results = await db.rawQuery(
      '''
        SELECT DISTINCT calculate
        FROM product_price 
        WHERE calculate IS NOT NULL
          AND pack_id = ?
        ORDER BY calculate ASC
        LIMIT 3
      ''', 
      [pack_id]
    );
    return results.map((row) => (row['calculate'] as num).toDouble()).toList();
  }


  Future<int> addPrice(ProductPrice productPrice, int pack_id) async {
    final db = await database;

    return await db.insert("product_price", {
      "price": productPrice.price,
      "piece": productPrice.piece,
      "quantity": productPrice.quantity,
      "note": productPrice.note,
      "pack_id": pack_id
    });
  }


  Future<int> updatePrice(ProductPrice productPrice) async {
    final db = await database;

    return await db.update(
      'product_price',
      productPrice.toMap(),
      where: 'id = ?',
      whereArgs: [productPrice.id],
    );
  }

  Future<int> deletePrice(int id) async {
    final db = await database;

    return await db.delete(
      'product_price',
      where: 'id = ?',
      whereArgs: [id],
    );
  }


  Future<int> deleteAllPrice(int pack_id) async {
    final db = await database;

    return await db.rawDelete("DELETE FROM product_price WHERE pack_id = ?", [pack_id]);
  }
}