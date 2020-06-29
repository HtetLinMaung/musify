import 'package:flutter/material.dart';
import 'package:music_player/store/audio.dart';
import 'package:provider/provider.dart';

class MusicTitle extends StatelessWidget {
  final String title;

  MusicTitle({this.title});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<Audio>();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
      ),
      child: Text(
        store.currentUrl.isNotEmpty ? store.getCurrentMusic().title : '',
        style: TextStyle(
          fontSize: 24.0,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
