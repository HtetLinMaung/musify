import 'package:flutter/material.dart';

const kBackgroundColor = Color(0xff250E41);
const kInputColor = Color(0xff9977B6);
const kInputFillColor = Color(0xff3C225C);
// const kPlayerActiveColor = Color(0xffFE17CD);
const kPlayerActiveColor = Color(0xffAC89C6);
const kPlayerIconColor = Color(0xffE5BBFF);
const kFavColor = Color(0xffFF16CD);
const kInActiveColor = Color(0xff402660);
const kBottomSheetColor = Color(0xffCE9CD7);
const kPlayerBackground = Color(0xff1B0434);
const kBottomSheetTextStyle = TextStyle(
  color: Color(0xff500D5B),
);
enum PlayerState { PLAYING, PAUSED, COMPLETED, STOPPED }
enum TrackState { SHUFFLE, LOOP, REPEAT }
enum MusicView { LIST, ALBUMN }
