import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:music_player/models/music.dart';

Future<Database> getDatabase() async {
  return openDatabase(
    join(await getDatabasesPath(), 'musify_database.db'),
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE favorites(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, url TEXT, favorite INTEGER)",
      );
    },
    version: 2,
  );
}

final Future<Database> database = getDatabase();

Future<void> insert({Music music, String table}) async {
  final Database db = await database;
  print('insert');
  await db.insert(
    table,
    music.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<Music>> getData({String table}) async {
  final Database db = await database;

  final List<Map<String, dynamic>> maps = await db.query(table);

  return List.generate(maps.length, (i) {
    return Music(
        id: maps[i]['id'],
        title: maps[i]['title'],
        url: maps[i]['url'],
        favorite: maps[i]['favorite'] == 0 ? false : true);
  });
}

Future<void> delete({int id, String table}) async {
  final db = await database;

  await db.delete(
    table,
    where: "id = ?",
    whereArgs: [id],
  );
}
