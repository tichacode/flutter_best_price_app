import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart'; // for databaseFactoryFfiWeb
import 'package:path_provider/path_provider.dart';

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
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE product_price (
        id INTEGER PRIMARY KEY, 
        price DECIMAL,
        piece DECIMAL,
        quantity DECIMAL,
        calculate DECIMAL(9, 2),
        note TEXT
      )
      '''
    );
  }


  Future<List<ProductPrice>> fetchPrice() async {
    final db = await database;

    final List<Map<String, Object?>> priceMaps = await db.query('product_price');

    return [
      for (final {'id': id as int, 'price': price as double, 'piece': piece as double, 'quantity': quantity as double, 'note': note as String}
          in priceMaps)
        ProductPrice(id: id, price: price, piece: piece, quantity: quantity, note:note),
    ];
  }

  Future<List<ProductCal>> calculatePrice() async {
    final db = await database;
    List<ProductCal> item = [];
    double calVal;

    final List<Map<String, Object?>> priceMaps = await db.query('product_price');

    for (final {'id': id as int, 'price': price as double, 'piece': piece as double, 'quantity': quantity as double, 'note': note as String} in priceMaps) {
        calVal = double.parse((price / (piece * quantity)).toStringAsFixed(2));
        item.add(ProductCal(id: id, price: price, piece: piece, quantity: quantity, calculate: calVal, note:note));
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

  Future<List<double>> bestPrice() async {
    final db = await database;

    final List<Map<String, dynamic>> results = await db.rawQuery(
      '''
        SELECT DISTINCT calculate
        FROM product_price 
        ORDER BY calculate ASC
        LIMIT 3
      ''',
    );
    return results.map((row) => row['calculate'] as double).toList();
  }


  Future<int> addPrice(ProductPrice productPrice) async {
    final db = await database;

    return await db.insert("product_price", {
      "price": productPrice.price,
      "piece": productPrice.piece,
      "quantity": productPrice.quantity,
      "note": productPrice.note
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


  Future<int> deleteAllPrice() async {
    final db = await database;

    return await db.rawDelete("DELETE FROM product_price");
  }
}