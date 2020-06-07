import 'package:flutter/cupertino.dart';

class Music {
  Music({@required this.title, @required this.url, this.favorite = false});

  final String title;
  final String url;
  bool favorite;

  toString() {
    return title;
  }
}
