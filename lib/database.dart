import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:music_player/models/music.dart';
import 'models/playlist.dart';

Future<Database> getDatabase() async {
  return openDatabase(
    join(await getDatabasesPath(), 'musify_database.db'),
    onCreate: (db, version) async {
      await db.execute(
        "CREATE TABLE favorites(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, url TEXT, favorite INTEGER);",
      );
      await db.execute(
          'CREATE TABLE playlists(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, filePath TEXT);');
    },
    onUpgrade: (db, oldVersion, newVersion) async {
      await db.execute(
        "CREATE TABLE IF NOT EXISTS favorites(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, url TEXT, favorite INTEGER);",
      );
      await db.execute(
          ' CREATE TABLE IF NOT EXISTS playlists(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, filePath TEXT);');
    },
    version: 8,
  );
}

final Future<Database> database = getDatabase();

Future<void> insertFavorite({Music music}) async {
  final Database db = await database;

  await db.insert(
    'favorites',
    music.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<void> insertPlaylist({Playlist playlist}) async {
  final Database db = await database;

  await db.insert(
    'playlists',
    playlist.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<Playlist>> getAllPlaylists() async {
  final Database db = await database;

  final List<Map<String, dynamic>> maps = await db.query('playlists');

  return List.generate(maps.length, (i) {
    return Playlist(
      filePath: maps[i]['filePath'],
      name: maps[i]['name'],
      id: maps[i]['id'],
    );
  });
}

Future<List<Music>> getAllFavorites() async {
  final Database db = await database;
  print(join(await getDatabasesPath(), 'musify_database.db'));

  final List<Map<String, dynamic>> maps = await db.query('favorites');

  return List.generate(maps.length, (i) {
    return Music(
        id: maps[i]['id'],
        title: maps[i]['title'],
        url: maps[i]['url'],
        favorite: maps[i]['favorite'] == 0 ? false : true);
  });
}

Future<void> deleteFavorite({
  String url,
}) async {
  final db = await database;

  await db.delete(
    'favorites',
    where: "url = ?",
    whereArgs: [url],
  );
}
