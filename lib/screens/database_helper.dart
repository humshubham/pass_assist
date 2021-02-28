import 'Password.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; //Single Ton
  static Database _database; //SingleTon

  String passTable = 'pass_table';
  String colId = 'id';
  String colTitle = 'title';
  String colUsername = 'username';
  String colPassword = 'password';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  // custom getter for database
  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'passwords.db';
    var passwordDatabase =
        await openDatabase(path, version: 2, onCreate: _createDb);

    return passwordDatabase;
  }

  void _createDb(Database db, int newversion) async {
    await db.execute(
        'CREATE TABLE $passTable ($colId INTEGER PRIMARY KEY AUTOINCREMENT,$colTitle TEXT,$colUsername  TEXT,$colPassword TEXT)');
  }

  Future<List<Map<String, dynamic>>> getPassMapList() async {
    Database db = await this.database;
    var result = await db.query(passTable, orderBy: '$colId ASC');
    return result;
  }

  Future<int> insertPass(Password pass) async {
    Database db = await this.database;
    var result = await db.insert(passTable, pass.toMap());
    return result;
  }

  Future<int> updatePass(Password pass) async {
    Database db = await this.database;
    var result = await db.update(passTable, pass.toMap(),
        where: '$colId=?', whereArgs: [pass.id]);
    return result;
  }

  Future<int> deletePass(int id) async {
    Database db = await database;
    var result = db.rawDelete('DELETE FROM $passTable where  $colId = $id');
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery("SELECT COUNT (*) FROM $passTable");
    int result = Sqflite.firstIntValue(x);
    // print(result);
    return result;
  }

  Future<List<Password>> getPassList() async {
    var passMapList = await getPassMapList();
    int count = passMapList.length;
    List<Password> passList = List<Password>();
    for (var i = 0; i < count; i++) {
      passList.add(Password.fromMapObject(passMapList[i]));
    }
    return passList;
  }
}
