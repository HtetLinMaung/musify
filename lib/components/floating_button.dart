import 'package:flutter/material.dart';
import 'package:music_player/constant.dart';
import 'package:music_player/store/audio.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';

class FloatingButton extends StatelessWidget {
  double _getPercentage(BuildContext context) {
    final duration = context.watch<Audio>().duration.inSeconds;
    final position = context.watch<Audio>().position.inSeconds;
    return position / duration;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      child: FittedBox(
        child: CircularPercentIndicator(
          radius: 60,
          lineWidth: 2,
          animateFromLastPercent: true,
          animation: true,
          animationDuration: 400,
          percent: _getPercentage(context),
          progressColor: kFavColor,
          backgroundColor: kPlayerIconColor,
          center: FloatingActionButton(
            autofocus: true,
            backgroundColor: kPlayerActiveColor,
            child: Icon(
              context.watch<Audio>().playerState == PlayerState.PLAYING
                  ? Icons.pause
                  : Icons.play_arrow,
              color: Colors.white,
            ),
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
    );
  }
}
