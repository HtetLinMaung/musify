import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:music_player/constant.dart';
import 'package:music_player/screens/player_screen.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class SleepTimerScreen extends StatefulWidget {
  static const routeName = 'SleepTimerScreen';

  @override
  _SleepTimerScreenState createState() => _SleepTimerScreenState();
}

class _SleepTimerScreenState extends State<SleepTimerScreen> {
  String _minutes = '00';
  String _seconds = '00';

  String prefixZero({String str, int max = 2}) {
    var newString = str;
    while (newString.length < max) {
      newString = '0' + newString;
    }
    return newString;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: SleekCircularSlider(
                min: 0,
                max: Duration(hours: 1).inSeconds.toDouble(),
                initialValue: 0.0,
                onChange: (v) {
                  if (v > 0) {
                    setState(() {
                      var totalSeconds = Duration(seconds: v.floor());
                      var minutes = totalSeconds.inMinutes;
                      var seconds = totalSeconds.inSeconds -
                          Duration(minutes: minutes).inSeconds;
                      _minutes = prefixZero(str: minutes.toString());
                      _seconds = prefixZero(str: seconds.toString());
                    });
                  }
                },
                appearance: CircularSliderAppearance(
                  startAngle: 270,
                  angleRange: 360,
                ),
                innerWidget: (v) => Text(''),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '$_minutes : $_seconds',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 52,
                    color: Color(0xff6B5587),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                RaisedButton(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25.0,
                      vertical: 15.0,
                    ),
                    child: Text(
                      'Start',
                    ),
                  ),
                  color: Color(0xff5750C4),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  onPressed: () {
                    Timer(
                      Duration(
                        minutes: int.parse(_minutes),
                        seconds: int.parse(_seconds),
                      ),
                      () {
                        AudioService.pause();
                      },
                    );
                    Navigator.pushNamed(context, PlayerScreen.routeName);
                  },
                ),
                SizedBox(
                  height: 50.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
