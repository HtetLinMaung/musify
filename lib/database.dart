import 'dart:async';

import 'package:music_player/models/music_image.dart';
import 'package:music_player/models/playlist_music.dart';
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
      await db.execute(
          'CREATE TABLE musics(id INTEGER PRIMARY KEY AUTOINCREMENT, url TEXT, playlistId INTEGER);');
      await db.execute(
          'CREATE TABLE music_images(id INTEGER PRIMARY KEY AUTOINCREMENT, imageUrl TEXT, musicUrl TEXT, albumName TEXT, artistName TEXT);');
    },
    onUpgrade: (db, oldVersion, newVersion) async {
      // await db.execute('DROP TABLE music_images');
      await db.execute(
        "CREATE TABLE IF NOT EXISTS favorites(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, url TEXT, favorite INTEGER);",
      );
      await db.execute(
          ' CREATE TABLE IF NOT EXISTS playlists(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, filePath TEXT);');
      await db.execute(
          'CREATE TABLE IF NOT EXISTS musics(id INTEGER PRIMARY KEY AUTOINCREMENT, url TEXT, playlistId INTEGER);');
      await db.execute(
          'CREATE TABLE IF NOT EXISTS music_images(id INTEGER PRIMARY KEY AUTOINCREMENT, imageUrl TEXT, musicUrl TEXT, albumName TEXT, artistName TEXT);');
    },
    version: 16,
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

Future<void> insertMusicByPlaylist({PlaylistMusic playlistMusic}) async {
  final Database db = await database;

  await db.insert(
    'musics',
    playlistMusic.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<void> insertImageByMusic({MusicImage musicImage}) async {
  final Database db = await database;

  await db.insert(
    'music_images',
    musicImage.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<void> deleteMusicByPlaylist({
  int playlistId,
}) async {
  final db = await database;

  await db.delete(
    'musics',
    where: "playlistId = ?",
    whereArgs: [playlistId],
  );
}

Future<void> updateImageByMusic(
    {MusicImage musicImage, String musicUrl}) async {
  final db = await database;

  await db.update(
    'music_images',
    musicImage.toMap(),
    where: "musicUrl = ?",
    whereArgs: [musicUrl],
  );
}

Future<void> updateFavoriteByUrl({Music music, String url}) async {
  final db = await database;

  await db.update(
    'favorites',
    music.toMap(),
    where: "url = ?",
    whereArgs: [url],
  );
}

Future<void> updatePlaylistMusicByUrl(
    {PlaylistMusic playlistMusic, String url}) async {
  final db = await database;

  await db.update(
    'musics',
    playlistMusic.toMap(),
    where: "url = ?",
    whereArgs: [url],
  );
}

Future<List<MusicImage>> getImageByMusic(String musicUrl) async {
  final Database db = await database;

  final List<Map<String, dynamic>> maps = await db.query(
    'music_images',
    where: 'musicUrl = ?',
    whereArgs: [musicUrl],
  );

  return List.generate(maps.length, (i) {
    return MusicImage(
      id: maps[i]['id'],
      imageUrl: maps[i]['imageUrl'],
      musicUrl: maps[i]['musicUrl'],
      albumName: maps[i]['albumName'],
      artistName: maps[i]['artistName'],
    );
  });
}

Future<void> updatePlaylist({Playlist playlist}) async {
  final db = await database;

  await db.update(
    'playlists',
    playlist.toMap(),
    where: "id = ?",
    whereArgs: [playlist.id],
  );
}

Future<void> deletePlaylist({
  int playlistId,
}) async {
  final db = await database;

  await db.delete(
    'playlists',
    where: "id = ?",
    whereArgs: [playlistId],
  );
  deleteMusicByPlaylist(playlistId: playlistId);
}

Future<void> deleteImageByMusic({
  String musicUrl,
}) async {
  final db = await database;

  await db.delete(
    'music_images',
    where: "musicUrl = ?",
    whereArgs: [musicUrl],
  );
  deleteFavorite(url: musicUrl);
  deletePlaylistMusicByUrl(url: musicUrl);
}

Future<void> deletePlaylistMusicByUrl({String url}) async {
  final db = await database;

  await db.delete(
    'musics',
    where: "url = ?",
    whereArgs: [url],
  );
}

Future<List<PlaylistMusic>> getMusicByPlaylist(int playlistId) async {
  final Database db = await database;

  final List<Map<String, dynamic>> maps = await db.query(
    'musics',
    where: 'playlistId = ?',
    whereArgs: [playlistId],
  );

  return List.generate(maps.length, (i) {
    return PlaylistMusic(
      id: maps[i]['id'],
      playlistId: maps[i]['playlistId'],
      url: maps[i]['url'],
    );
  });
}

Future<List<PlaylistMusic>> getPlaylistMusicByUrl({String url}) async {
  final Database db = await database;

  final List<Map<String, dynamic>> maps = await db.query(
    'musics',
    where: 'url = ?',
    whereArgs: [url],
  );

  return List.generate(maps.length, (i) {
    return PlaylistMusic(
      id: maps[i]['id'],
      playlistId: maps[i]['playlistId'],
      url: maps[i]['url'],
    );
  });
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

Future<List<PlaylistMusic>> getAllPlaylistMusics() async {
  final Database db = await database;

  final List<Map<String, dynamic>> maps = await db.query('musics');

  return List.generate(maps.length, (i) {
    return PlaylistMusic(
      playlistId: maps[i]['playlistId'],
      url: maps[i]['url'],
      id: maps[i]['id'],
    );
  });
}

Future<List<Music>> getAllFavorites() async {
  final Database db = await database;

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
