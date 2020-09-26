import 'dart:async';

import 'package:note_keeper_001/models/list_item.dart';
import 'package:note_keeper_001/models/shopping_list.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  final int version = 1;
  Database db;
  DbHelper._internal();
  static final DbHelper _dbHelper = DbHelper._internal();

  factory DbHelper() {
    return _dbHelper;
  }

  Future<Database> openDb() async {
    if (db == null) {
      db = await openDatabase(
          join(
            await getDatabasesPath(),
            'shopping.db',
          ), onCreate: (database, version) {
        database.execute(
            'CREATE TABLE lists(id INTEGER PRIMARY KEY, name TEXT,priority INTEGER)');
        database.execute(
            'CREATE TABLE items(id INTEGER PRIMARY KEY,idList INTEGER,name TEXT, quantity TEXT,note TEXT,isDone TEXT,' +
                'FOREIGN KEY(idList) REFERENCES lists(id))');
      }, version: version);
    }
    return db;
  }

  Future<int> insertList(ShoppingList list) async {
    int id = await this.db.insert('lists', list.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return id;
  }

  Future<int> insertItem(ListItem item) async {
    int id = await this.db.insert('items', item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return id;
  }

  Future<List<ShoppingList>> getLists() async {
    final List<Map<String, dynamic>> maps =
        await db.query('lists', orderBy: 'id DESC');

    return List.generate(maps.length, (index) {
      return ShoppingList(
        maps[index]['id'],
        maps[index]['name'],
        maps[index]['priority'],
      );
    });
  }

  Future<List<ListItem>> getItems(int idList) async {
    final List<Map<String, dynamic>> maps = await db.query('items',
        where: 'idList = ?', whereArgs: [idList], orderBy: 'id DESC');

    return List.generate(maps.length, (index) {
      return ListItem(
        maps[index]['id'],
        maps[index]['idList'],
        maps[index]['name'],
        maps[index]['quantity'],
        maps[index]['note'],
        maps[index]['isDone'],
        doneDoneBuying: stringToBool(maps[index]['isDone']),
      );
    });
  }

  Future<int> deleteList(ShoppingList list) async {
    int result =
        await db.delete('items', where: "idList = ?", whereArgs: [list.id]);

    result = await db.delete('lists', where: "id = ?", whereArgs: [list.id]);
    return result;
  }

  // ignore: missing_return
  Future<int> deleteItem(ListItem item) async {
    // ignore: unused_local_variable
    int result =
        await db.delete('items', where: "id = ?", whereArgs: [item.id]);
    return result;
  }

  Future<int> deleteAllItem(int id) async {
    int result = await db.delete('items', where: "idList = ?", whereArgs: [id]);
    return result;
  }

  Future queryAll() async {
    var list = await db.query('lists');
    var item = await db.query('items');
    print(list);
    print(item);
  }

  Future clearDb() async {
    var list = await db.delete('lists');
    var item = await db.delete('items');
    print(list);
    print(item);
  }

  stringToBool(String value) {
    switch (value) {
      case 'true':
        return true;
        break;
      case 'false':
        return false;
        break;
    }
  }
}
