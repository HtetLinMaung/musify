import 'package:flutter/material.dart';

class Playlist {
  Playlist({
    @required this.name,
    @required this.filePath,
    this.id,
  });

  final int id;
  final String name;
  final String filePath;

  toString() {
    return name;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'filePath': filePath,
    };
  }
}
