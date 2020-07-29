
import 'package:e_wallet/models/wallet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;

class WalletsDatabase {
  static Database _database;

  static final WalletsDatabase _singleton =
  new WalletsDatabase._internal();

  factory WalletsDatabase() {
    return _singleton;
  }

  WalletsDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDb();
    return _database;
  }

  Future<Database> initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "wallets.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

//  id": 6,
//  "user": 16,
//  "currency": 104,
//  "balance": 1281,
//  "value_buy": 21930.210000000003,
//  "value_sell": 21367.079999999998,
//  "profit": -563.1300000000047

  void _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE wallets(id INTEGER PRIMARY KEY, user INTEGER, currency INTEGER,'
          '  balance INTEGER, value_buy DOUBLE, value_sell DOUBLE, profit DOUBLE)',
    );
  }

  Future<int> newWallet(Wallet wallet) async {
    Database db = await this.database;
    var res = await db.insert('wallets', wallet.toMap());
    return res;
  }

  Future<int> updateWallet(Wallet wallet) async {
    final db = await this.database;
    var res = await db.update('wallets', wallet.toMap(),
        where: "id = ?", whereArgs: [wallet.id]);
    return res;
  }

  Future<int> deleteWallet(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM wallets where id = $id');
    return result;
  }

  Future<List<Map<String, dynamic>>> getWalletsList() async {
    Database db = await this.database;
    var result = await db.query('wallets');

    return result;
  }

  Future<List<Wallet>> getWalletsFromDb() async {
    var walletList = await getWalletsList();
    int count = walletList.length;

    List<Wallet> productList = List<Wallet>();
    for (int i = 0; i < count; i++) {
      productList.add(Wallet.fromJson(walletList[i]));
    }

    print(walletList.length.toString());

    return productList;
  }

}