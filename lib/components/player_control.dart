import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:music_player/constant.dart';
import 'package:music_player/store/audio.dart';
import 'prev_button.dart';
import 'next_button.dart';

class PlayerControl extends StatelessWidget {
  Icon getIcon(Audio store) {
    switch (store.trackState) {
      case TrackState.LOOP:
        return Icon(Icons.repeat);
      case TrackState.SHUFFLE:
        return Icon(Icons.shuffle);
      default:
        return Icon(Icons.repeat_one);
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<Audio>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          color: kPlayerIconColor,
          icon: getIcon(store),
          onPressed: () {
            final store = context.read<Audio>();
            switch (store.trackState) {
              case TrackState.LOOP:
                store.setTrackState(TrackState.SHUFFLE);
                break;
              case TrackState.SHUFFLE:
                store.setTrackState(TrackState.REPEAT);
                break;
              default:
                store.setTrackState(TrackState.LOOP);
            }
          },
        ),
        PrevButton(),
        Ink(
          decoration: const ShapeDecoration(
            shape: CircleBorder(),
            color: kPlayerActiveColor,
          ),
          child: SizedBox(
            width: 70,
            height: 70,
            child: IconButton(
              iconSize: 25.0,
              icon: Icon(store.playerState == PlayerState.PLAYING
                  ? Icons.pause
                  : Icons.play_arrow),
              onPressed: () {
                final store = context.read<Audio>();
                if (store.playerState == PlayerState.PLAYING) {
                  store.pause();
                } else {
                  store.resume();
                }
              },
            ),
          ),
        ),
        NextButton(),
        IconButton(
          color: kPlayerIconColor,
          icon: Icon(!store.muted ? Icons.volume_up : Icons.volume_off),
          onPressed: () {
            context.read<Audio>().mute();
          },
        )
      ],
    );
  }
}
