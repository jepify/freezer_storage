import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class DatabaseHelper {
  static final _databaseName = "storage.db";
  static final _databaseVersion = 1;

  // make this class singleton
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // single database connection
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
//    await db.execute('''
//          CREATE TABLE my_table (
//            _id INTEGER PRIMARY KEY,
//            name TEXT NOT NULL
//          )
//
//    ''');
  }

  Future<int> insert(Map<String, dynamic> row, String tableName) async {
    Database db = await instance.database;
    return await db.insert(tableName, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows(String tableName) async {
    Database db = await instance.database;
    return await db.query(tableName);
  }

  // creates a new table based on given string
  void newTable(String tableName) async {
    Database db = await instance.database;
    await db.execute('''
          CREATE TABLE $tableName (
          _id INTEGER PRIMARY KEY,
          name TEXT NOT NULL
          )
    ''');
  }

  Future<List<String>> getAllTables() async {
    Database db = await instance.database;

    List<Map<String, dynamic>> tables = await db.rawQuery('''
          SELECT name FROM sqlite_master WHERE type = 'table' AND name NOT LIKE 'sqlite_%' AND name NOT LIKE'android_%';
    ''');

    return new List.generate(tables.length, (i) => tables[i]['name']);
  }
}
