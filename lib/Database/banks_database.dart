
import 'package:e_wallet/models/bank.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;

class BanksDatabase {
  static Database _database;

  static final BanksDatabase _singleton =
  new BanksDatabase._internal();

  factory BanksDatabase() {
    return _singleton;
  }

  BanksDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDb();
    return _database;
  }

  Future<Database> initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "banks.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

//  {
//  "id": 15,
//  "registered_name": "Moldova Agroindbank",
//  "short_name": "MAIB",
//  "website": ""
//  },

  void _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE banks(id INTEGER PRIMARY KEY, registered_name TEXT, short_name TEXT)',
    );
  }

  Future<int> newBank(Bank bank) async {
    Database db = await this.database;
    var res = await db.insert('banks', bank.toMap());
    return res;
  }

  Future<int> updateBank(Bank bank) async {
    final db = await this.database;
    var res = await db.update('banks', bank.toMap(),
        where: "id = ?", whereArgs: [bank.id]);
    return res;
  }

  Future<int> deleteBank(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM banks where id = $id');
    return result;
  }

  Future<List<Map<String, dynamic>>> getBanksList() async {
    Database db = await this.database;
    var result = await db.query('banks');

    return result;
  }

  Future<List<Bank>> getBanksFromDb() async {
    var bankList = await getBanksList();
    int count = bankList.length;

    List<Bank> productList = List<Bank>();
    for (int i = 0; i < count; i++) {
      productList.add(Bank.fromJson(bankList[i]));
    }

    print(productList.length.toString());

    return productList;
  }

}