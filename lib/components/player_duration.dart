import 'package:flutter/material.dart';
import 'package:music_player/constant.dart';

class PlayerDuration extends StatelessWidget {
  const PlayerDuration({
    Key key,
    @required this.d,
  }) : super(key: key);

  final Duration d;

  String formatDurationString(String str) {
    final array = str.split(':');
    return '${array[1]}:${array[2].split('.')[0]}';
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      formatDurationString(d.toString()),
      style: TextStyle(
        color: kPlayerIconColor,
      ),
    );
  }
}
