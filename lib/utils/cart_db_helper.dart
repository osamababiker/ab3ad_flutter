// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:ab3ad/models/Cart.dart';

class CartDatabaseHelper extends ChangeNotifier {
  static final CartDatabaseHelper _instance = CartDatabaseHelper.internal();

  factory CartDatabaseHelper() => _instance;
  final String table = "cart";
  final String id = "id";
  final String itemId = "itemId";
  final String categoryId = "categoryId";
  final String name = "name";
  final String image = "image";
  final String price = "price";
  final String quantity = "quantity";
  final String deliveryTime = "deliveryTime";
  final String deliveryNote = "deliveryNote";

  Future<Database> get db async {
    Database _db;
    _db = await initDb();
    return _db;
  }

  initDb() async {
    //deleteDB();
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "maindb.db");
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE $table($id INTEGER PRIMARY KEY AUTOINCREMENT, $itemId INTEGER, $categoryId INTEGER, $name TEXT, $image TEXT , $price TEXT, $deliveryTime TEXT, $deliveryNote TEXT, $quantity INTEGER)");
  }

  /*================== CRUD ===================*/

  addToCart({required Map<String, dynamic> cartData}) async {
    var dbClient = await db;
    var id = cartData['itemId'];
    var result = await dbClient
        .rawQuery("SELECT id , quantity FROM $table WHERE $itemId = $id");
    if (result.isEmpty) {
      saveItem(cartData: cartData);
    } else {
      int id = result[0]['id'] as int;
      int quantity = result[0]['quantity'] as int;
      cartData['quantity'] += quantity;
      updateQuantity(cartData: cartData, id: id);
    }
  }

  // INSERTIONG
  Future<int> saveItem({required Map<String, dynamic> cartData}) async {
    var dbClient = await db;
    try{
      int item = await dbClient.insert(table, cartData);
      notifyListeners();
      return item;
    }catch(e){
      print("problem Insert item === ${e}");
      throw(e);
    }
  }

  // Selecting
  Future<List> getItems() async {
    var dbclient = await db;
    try {
      List<Map<String, dynamic>> maps =
          await dbclient.query("$table", columns: [
        "$id",
        "$itemId",
        "$categoryId",
        "$name",
        "$image",
        "$price",
        "$quantity",
        "$deliveryTime",
        "$deliveryNote"
      ]);
      List<Cart> products = [];
      if (maps.isNotEmpty) {
        for (int i = 0; i < maps.length; i++) {
          products.add(Cart.fromMap(maps[i]));
        }
      }
      return products;
    } catch (e) {
      print("problem selecting all items == ${e}");
      throw (e);
    }
  }

  Future<double> getCartTotal() async {
    var dbclient = await db;
    var total = 0.0;
    var cartData = [];
    try {
      cartData = await dbclient.rawQuery("SELECT * FROM $table");
      for (var i = 0; i < cartData.length; i++) {
        Cart cart = Cart.fromMap(cartData[i]);
        total += double.parse(cart.price) * cart.quantity;
      }
    } catch (e) {
      print("problem selecting all items == ${e}");
      throw (e);
    }
    return total;
  }

  // GETTING COUNT
  Future<int> getCount() async {
    var dbClient = await db;
    var numOfItems = 0;
    try {
      numOfItems = Sqflite.firstIntValue(
          await dbClient.rawQuery("SELECT COUNT(*) FROM $table"))!;
    } catch (e) {
      print("problem getting count == ${e}");
      throw (e);
    }
    return numOfItems;
  }

  // DELETEING ITEM
  Future<int> deleteItem(int itemId) async {
    var dbClient = await db;
    try {
      int deleteItem = await dbClient
          .delete("$table", where: "$id = ?", whereArgs: [itemId]);
      notifyListeners();
      return deleteItem;
    } catch (e) {
      print("problem deleteing Item == ${e}");
      throw (e);
    }
  }

  // UPDATING
  Future<int> updateQuantity(
      {required Map<String, dynamic> cartData, required int id}) async {
    var dbClient = await db;
    print(cartData['quantity']);
    try {
      int updateItem = await dbClient
          .update(table, cartData, where: '$id = ?', whereArgs: [id]);
      notifyListeners();
      return updateItem;
    } catch (e) {
      print("problem updating Item quantity == ${e}");
      throw (e);
    }
  }

  // DELETEING DATABASE
  deleteDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'maindb.db');
    try {
      await deleteDatabase(path);
    } catch (e) {
      print("problem deleting database == ${e}");
      throw (e);
    }
  }

  // CLOSING CONNECTION
  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }

  CartDatabaseHelper.internal();
}
