import 'package:flutter/material.dart';
import 'package:music_player/constant.dart';
import 'package:flutter/services.dart';
import 'package:music_player/components/player_option.dart';
import 'package:music_player/components/player_progress.dart';
import 'package:music_player/components/music_title.dart';
import 'package:music_player/components/album_cover.dart';
import 'package:music_player/components/player_control.dart';
import 'package:music_player/screens/home_screen.dart';

class PlayerScreen extends StatefulWidget {
  static const routeName = 'PlayerScreen';

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(context, HomeScreen.routeName);
        return false;
      },
      child: Scaffold(
        backgroundColor: kPlayerBackground,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              AlbumCorver(),
              MusicTitle(),
              PlayerProgress(),
              PlayerControl(),
              PlayerOption()
            ],
          ),
        ),
      ),
    );
  }
}
