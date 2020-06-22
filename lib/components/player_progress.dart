import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:music_player/constant.dart';
import 'package:provider/provider.dart';
import 'package:music_player/store/audio.dart';
import 'package:music_player/components/player_duration.dart';

class PlayerProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final store = context.watch<Audio>();

    return Column(
      children: <Widget>[
        Slider(
          activeColor: kPlayerActiveColor,
          inactiveColor: kInActiveColor,
          min: 0,
          max: store.duration.inSeconds.roundToDouble(),
          value: store.position.inSeconds.roundToDouble(),
          onChanged: (v) {
            context.read<Audio>().seek(v);
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              PlayerDuration(
                d: store.position,
              ),
              PlayerDuration(
                d: store.duration,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
