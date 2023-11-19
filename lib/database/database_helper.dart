import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:newsqlite/database/strings.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _db;

  Future<Database> get db async {
    _db ??= await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    if (kDebugMode) {
      print(dbPath);
    }
    final database = await openDatabase(
      '$dbPath/${Strings.dbName}',
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE ${Strings.tableUsers} (
            ${Strings.columnID} INTEGER PRIMARY KEY AUTOINCREMENT,
            ${Strings.columnName} TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE ${Strings.tablePosts} (
            ${Strings.columnID} INTEGER PRIMARY KEY AUTOINCREMENT,
            ${Strings.columnUserID} INTEGER NOT NULL REFERENCES ${Strings.tableUsers}(${Strings.columnID}),
          ${Strings.columnTitle} TEXT NOT NULL,
         ${Strings.columnContent} TEXT NOT NULL
          )
        ''');
      },
      version: 1,
    );
    return database;
  }


}
