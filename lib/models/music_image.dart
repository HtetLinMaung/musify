import 'package:flutter/material.dart';

class MusicImage {
  MusicImage({
    @required this.musicUrl,
    @required this.imageUrl,
    this.albumName,
    this.id,
    this.artistName,
  });

  final int id;
  final String musicUrl;
  final String imageUrl;
  final String albumName;
  final String artistName;

  toString() {
    return imageUrl;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'musicUrl': musicUrl,
      'imageUrl': imageUrl,
      'albumName': albumName,
      'artistName': artistName,
    };
  }
}
