import 'package:flutter/material.dart';

class PlaylistMusic {
  PlaylistMusic({
    @required this.url,
    @required this.playlistId,
    this.id,
  });

  final int id;
  final String url;
  final int playlistId;

  toString() {
    return url;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url': url,
      'playlistId': playlistId,
    };
  }
}
