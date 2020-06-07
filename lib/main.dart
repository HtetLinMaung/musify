import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:music_player/store/audio.dart';
import 'package:music_player/constant.dart';
import 'package:music_player/screens/home_screen.dart';
import 'package:music_player/screens/player_screen.dart';

void main() => runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Audio(),
        )
      ],
      child: MusicPlayer(),
    ));

class MusicPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:
          ThemeData.dark().copyWith(scaffoldBackgroundColor: kBackgroundColor),
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (context) => HomeScreen(),
        PlayerScreen.routeName: (context) => PlayerScreen(),
      },
    );
  }
}