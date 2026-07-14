import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:flutter/foundation.dart'; // for kIsWeb
import 'dart:io'; //for Platform
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart'; // for databaseFactoryFfiWeb
// import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // for databaseFactoryFfi

import 'package:flutter/widgets.dart';
// import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class ProductPrice {
  final int id;
  final int price;
  final int piece;
  final int quantity; //per unit
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

    // if (kIsWeb) {
    //   databaseFactory = databaseFactoryFfiWeb;
    //   pathDb = 'ProductPrice_database.db'; 
    // } else {
    //   // if (Platform.isLinux || Platform.isWindows) {
    //   //   databaseFactory = databaseFactoryFfi;
    //   // }
    //   pathDb = join(await getDatabasesPath(), 'ProductPrice_database.db');
    // }

    if (kIsWeb) {
      databaseFactoryOrNull = databaseFactoryFfiWeb;
      pathDb = 'ProductPrice_database.db'; 

    } else {
      var databasesPath = await getApplicationDocumentsDirectory();
      pathDb = join(databasesPath.path, 'ProductPrice_database.db');
    }

    // String path = join(await getDatabasesPath(), 'app_database.db');
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
        price INTEGER,
        piece INTEGER,
        quantity INTEGER,
        note TEXT
      )
      '''
    );
  }





  Future<List<ProductPrice>> fetchPrice() async {
    final db = await database;

    final List<Map<String, Object?>> priceMaps = await db.query('product_price');

    return [
      for (final {'id': id as int, 'price': price as int, 'piece': piece as int, 'quantity': quantity as int, 'note': note as String}
          in priceMaps)
        ProductPrice(id: id, price: price, piece: piece, quantity: quantity, note:note),
    ];
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
}