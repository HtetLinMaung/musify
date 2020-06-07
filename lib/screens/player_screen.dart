import 'package:flutter/material.dart';
import 'package:music_player/store/audio.dart';
import 'package:provider/provider.dart';
import 'package:music_player/constant.dart';
import 'package:flutter/services.dart';

class PlayerScreen extends StatefulWidget {
  static const routeName = 'PlayerScreen';

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  Icon getIcon() {
    final store = context.watch<Audio>();
    switch (store.trackState) {
      case TrackState.LOOP:
        return Icon(Icons.repeat);
      case TrackState.SHUFFLE:
        return Icon(Icons.shuffle);
      default:
        return Icon(Icons.repeat_one);
    }
  }

  String formatDurationString(String str) {
    final array = str.split(':');
    return '${array[1]}:${array[2].split('.')[0]}';
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: CircleAvatar(
                radius: 120.0,
                backgroundImage: AssetImage('assets/images/headphone.jpeg'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15.0,
              ),
              child: Text(
                context.watch<Audio>().getCurrentMusic().title,
                style: TextStyle(
                  fontSize: 24.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Column(
              children: <Widget>[
                Slider(
                  activeColor: kPlayerActiveColor,
                  min: 0,
                  max:
                      context.watch<Audio>().duration.inSeconds.roundToDouble(),
                  value:
                      context.watch<Audio>().position.inSeconds.roundToDouble(),
                  onChanged: (v) {
                    context.read<Audio>().seek(v);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        formatDurationString(
                            context.watch<Audio>().position.toString()),
                        style: TextStyle(
                          color: kPlayerIconColor,
                        ),
                      ),
                      Text(
                        formatDurationString(
                            context.watch<Audio>().duration.toString()),
                        style: TextStyle(
                          color: kPlayerIconColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  color: kPlayerIconColor,
                  icon: getIcon(),
                  onPressed: () {
                    final store = context.read<Audio>();
                    switch (store.trackState) {
                      case TrackState.LOOP:
                        store.setTrackState(TrackState.SHUFFLE);
                        break;
                      case TrackState.SHUFFLE:
                        store.setTrackState(TrackState.SINGLE);
                        break;
                      default:
                        store.setTrackState(TrackState.LOOP);
                    }
                  },
                ),
                IconButton(
                  color: kPlayerIconColor,
                  icon: Icon(Icons.skip_previous),
                  onPressed: () {
                    context.read<Audio>().previous();
                  },
                ),
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
                      icon: Icon(context.watch<Audio>().playerState ==
                              PlayerState.PLAYING
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
                IconButton(
                  color: kPlayerIconColor,
                  icon: Icon(Icons.skip_next),
                  onPressed: () {
                    context.read<Audio>().next();
                  },
                ),
                IconButton(
                  color: kPlayerIconColor,
                  icon: Icon(!context.watch<Audio>().muted
                      ? Icons.volume_up
                      : Icons.volume_off),
                  onPressed: () {
                    context.read<Audio>().mute();
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
