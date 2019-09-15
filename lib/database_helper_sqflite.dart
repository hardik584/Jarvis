import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class Database_helper {
  static final _databaseName = "student";
  static final _databaseVesrion = 1;
  static final table = "User";
  static final ColumnId = "id";
  static final ColumnFirstName = "first_name";
  static final ColumnLastName = "last_name";
  static final ColumnEmailId = "email";
  static final ColumnAvatar = "avatar";

  Database_helper._private();
  static final Database_helper instance = Database_helper._private();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await initDatabase();
      return _database;
    }
  }

  initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _databaseName);
    return openDatabase(path,
        version: _databaseVesrion, onCreate: _CreateDatabase);
  }

  Future _CreateDatabase(Database db, int version) async {
    String sql = '''
    CREATE TABLE $table(
      $ColumnId INTEGER PRIMARY KEY,
      $ColumnFirstName TEXT NOT NULL,
      $ColumnLastName TEXT NOT NULL,
      $ColumnEmailId TEXT NOT NULL,
      $ColumnAvatar TEXT NOT NULL

    )
    ''';
    await db.execute(sql);
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return db.insert(table, row);
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return db
        .update(table, row, where: "$ColumnId=?", whereArgs: [row["id"]]);
  }

  Future<List<Map<String, dynamic>>> read() async {
    Database db = await instance.database;
    return db.query(table);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return db.delete(table, where: "$ColumnId=?", whereArgs: [id]);
  }
}
