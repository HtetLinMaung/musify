import 'package:flutter/material.dart';
import 'package:music_player/constant.dart';
import 'package:provider/provider.dart';
import 'package:music_player/store/audio.dart';

class PrevButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: kPlayerIconColor,
      icon: Icon(Icons.skip_previous),
      onPressed: () {
        context.read<Audio>().previous();
      },
    );
  }
}
