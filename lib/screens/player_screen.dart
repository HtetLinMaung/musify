import 'package:flutter/material.dart';
import 'package:music_player/store/audio.dart';
import 'package:provider/provider.dart';
import 'package:music_player/constant.dart';
import 'package:flutter/services.dart';
import 'package:music_player/components/next_button.dart';
import 'package:music_player/components/prev_button.dart';
import 'package:music_player/database.dart';
import 'package:music_player/components/modal_sheet.dart';
import 'package:music_player/components/edit_column.dart';

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

    final store = context.watch<Audio>();

    return Scaffold(
      backgroundColor: kPlayerBackground,
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
                store.getCurrentMusic().title,
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
                      Text(
                        formatDurationString(store.position.toString()),
                        style: TextStyle(
                          color: kPlayerIconColor,
                        ),
                      ),
                      Text(
                        formatDurationString(store.duration.toString()),
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
            ),
            Container(
              decoration: BoxDecoration(
                color: Color(0xff260F42),
                borderRadius: BorderRadius.circular(30.0),
              ),
              padding: EdgeInsets.symmetric(
                vertical: 16.0,
              ),
              margin: EdgeInsets.symmetric(
                horizontal: 18.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return ModalSheet(
                            child: EditColumn(),
                            height: 300,
                          );
                        },
                      );
                    },
                    icon: Icon(
                      Icons.more_horiz,
                      color: kPlayerIconColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.playlist_play,
                      color: kPlayerIconColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      final store = context.read<Audio>();
                      store.getCurrentMusic().favorite =
                          !store.getCurrentMusic().favorite;
                      final music = store.getCurrentMusic();
                      if (music.favorite) {
                        insert(music: music, table: 'favorites');
                      } else {
                        delete(url: music.url, table: 'favorites');
                      }
                    },
                    icon: Icon(
                      Icons.favorite,
                      color: store.getCurrentMusic().favorite
                          ? kFavColor
                          : kPlayerIconColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
