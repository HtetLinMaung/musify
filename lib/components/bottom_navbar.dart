import 'package:flutter/material.dart';
import 'package:music_player/constant.dart';
import 'package:music_player/screens/player_screen.dart';
import 'package:provider/provider.dart';
import 'package:music_player/store/audio.dart';
import 'next_button.dart';
import 'prev_button.dart';
import 'package:marquee/marquee.dart';

class BottomNavbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: kBackgroundColor,
      child: GestureDetector(
        onVerticalDragEnd: (details) {
          Navigator.pushNamed(context, PlayerScreen.routeName);
        },
        child: Container(
          height: 85.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(35),
              topRight: Radius.circular(35),
            ),
            color: Color(0xff3C225C),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              PrevButton(),
              Expanded(
                child: Marquee(
                  text: context.watch<Audio>().getCurrentMusic().title,
                  velocity: 25.0,
                  style: TextStyle(
                    color: Color(0xffEBE2F4),
                  ),
                ),
              ),
              NextButton(),
            ],
          ),
        ),
      ),
    );
  }
}
