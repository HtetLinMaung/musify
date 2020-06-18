import 'package:flutter/material.dart';

class Music {
  Music({
    @required this.title,
    @required this.url,
    this.favorite = false,
    this.id,
  });

  final int id;
  final String title;
  final String url;
  bool favorite;

  toString() {
    return title;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'favorite': favorite ? 1 : 0,
    };
  }
}
