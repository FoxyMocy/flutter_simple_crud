import 'package:crud_app/item_model.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        description TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }
// id: the id of a item
// title, description: name and description of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'todolist.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
        
      },
    );
    
  }

  // Create new item (journal)
  static Future<int> createItem(ItemTodo items) async {
    final db = await SQLHelper.db();

    // final data = {'title': title, 'description': descrption};
    final id = await db.insert('items', items.toMap(),
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }


  // Read all items (journals)
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('items', orderBy: "id");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateItem(
    ItemTodo items
      // int id, String title, String? descrption
      ) async {
    final db = await SQLHelper.db();

    final result =
        await db.update('items', items.toMap(), where: "id = ?", whereArgs: [items.id]);
    return result;
  }

  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  
}