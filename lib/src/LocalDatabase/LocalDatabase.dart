import 'dart:async';
import 'dart:io';

import 'package:food_app/src/models/fav.dart';
import 'package:food_app/src/models/food_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

// ignore: camel_case_types
class localDatabase {
  localDatabase._();
  static final localDatabase db = localDatabase._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "FodiesDatabase.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Foods ("
          "id INTEGER PRIMARY KEY,"
          "category TEXT,"
          "count TEXT"
          ")");
      await db.execute("CREATE TABLE Fav ("
          "id INTEGER PRIMARY KEY,"
          "category TEXT"
          ")");
    });
  }

  insertFood(Food food) async {
    // Get a reference to the database.
    final db = await database;

    var res = await db.insert("Foods", food.toMap());
    return res;
  }

  insertFav(Fav fav) async {
    // Get a reference to the database.
    final db = await database;

    var res = await db.insert("Fav", fav.toMap());
    return res;
  }

  Future<List<Food>> foods() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('Foods');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Food(
        id: maps[i]['id'],
        category: maps[i]['category'],
        count: int.parse(maps[i]['count']),
      );
    });
  }

  Future<List<Fav>> favs() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('Fav');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Fav(id: maps[i]['id'], category: maps[i]['category']);
    });
  }

  Future<int> checkFood(int id) async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM Foods WHERE id=$id'));
  }

  Future<int> checkFav(int id) async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM Fav WHERE id=$id'));
  }

  Future<void> updateFood(int id, int count) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given Dog.
    await db.rawQuery("UPDATE Foods SET count = $count WHERE id=$id");
  }

  Future<void> deleteFood(int id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the database.
    await db.delete(
      'Foods',
      // Use a `where` clause to delete a specific dog.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  Future<void> deleteFav(int id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the database.
    await db.delete(
      'Fav',
      // Use a `where` clause to delete a specific dog.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  Future<void> deleteFoods() async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the database.
    await db.delete(
      'Foods',
    );
  }

  Future<void> deleteFavs() async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the database.
    await db.delete(
      'Fav',
    );
  }
}
