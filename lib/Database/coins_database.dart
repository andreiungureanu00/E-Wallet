
import 'package:e_wallet/models/coin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;

class CoinsDatabase {
  static Database _database;

  static final CoinsDatabase _singleton =
  new CoinsDatabase._internal();

  factory CoinsDatabase() {
    return _singleton;
  }

  CoinsDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDb();
    return _database;
  }

  Future<Database> initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "coins.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }
//
//  "id": 81,
//  "name": "US Dollar",
//  "abbr": "USD",
//  "bank": 15

  void _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE coins(id INTEGER PRIMARY KEY, name TEXT, abbr TEXT, bank INTEGER)',
    );
  }

  Future<int> newCoin(Coin coin) async {
    Database db = await this.database;
    var res = await db.insert('coins', coin.toMap());
    return res;
  }

  Future<int> updateCoin(Coin coin) async {
    final db = await this.database;
    var res = await db.update('coins', coin.toMap(),
        where: "id = ?", whereArgs: [coin.id]);
    return res;
  }

  Future<int> deleteCoin(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM coins where id = $id');
    return result;
  }

  Future<List<Map<String, dynamic>>> getCoinsList() async {
    Database db = await this.database;
    var result = await db.query('coins');

    return result;
  }

  Future<List<Coin>> getCoinsFromDb() async {
    var coinList = await getCoinsList();
    int count = coinList.length;

    List<Coin> productList = List<Coin>();
    for (int i = 0; i < count; i++) {
      productList.add(Coin.fromJson(coinList[i]));
    }

    print(coinList.length.toString());

    return productList;
  }

}