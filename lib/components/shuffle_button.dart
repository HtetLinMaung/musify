import 'package:flutter/material.dart';
import 'package:music_player/constant.dart';
import 'package:provider/provider.dart';
import 'package:music_player/store/audio.dart';

class ShuffleButton extends StatelessWidget {
  ShuffleButton({this.play = Play.NONE});

  final Play play;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      color: kInActiveColor,
      onPressed: () => context.read<Audio>().shufflePlay(play: play),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.shuffle,
            color: kPlayerIconColor,
            size: 14,
          ),
          Text(
            ' Shuffle',
            style: TextStyle(
              color: kPlayerIconColor,
            ),
          ),
        ],
      ),
    );
  }
}
