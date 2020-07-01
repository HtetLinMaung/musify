import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music_player/constant.dart';
import 'package:music_player/screens/edit_music_screen.dart';
import 'package:music_player/screens/home_screen.dart';
import 'package:music_player/screens/sleep_timer_screen.dart';
import 'text_button.dart';
import 'package:provider/provider.dart';
import 'package:music_player/store/audio.dart';
import 'package:music_player/database.dart';
import 'package:music_player/screens/add_music_playlist.dart';

class EditColumn extends StatelessWidget {
  final String url;

  EditColumn({this.url = ''});

  Future<void> _showDeleteDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: kBottomSheetColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35),
          ),
          title: Text(
            'Are you sure you want to delete?',
            textAlign: TextAlign.center,
          ),
          titleTextStyle: TextStyle(fontSize: 18),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35),
                  ),
                  color: Color(0xffF06B94),
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35),
                  ),
                  color: Color(0xffA376AF),
                  child: Text('Yes'),
                  onPressed: () async {
                    final store = context.read<Audio>();
                    var musicUrl = store.currentUrl;
                    if (url.isNotEmpty) {
                      musicUrl = url;
                    }
                    store.setPlay(Play.NONE);
                    store.setForceHideBottomNavBar(true);
                    if (url == store.currentUrl || url.isEmpty) {
                      store.setCurrentUrl(url: '', sync: false);
                      if (store.playerState == PlayerState.PLAYING) {
                        store.next();
                      }
                    }
                    store.setMusicList(store.musicList
                        .where((music) => music.url != musicUrl)
                        .toList());

                    File(musicUrl).delete();
                    await deleteImageByMusic(musicUrl: musicUrl);
                    store.setForceHideBottomNavBar(false);
                    Navigator.popAndPushNamed(context, HomeScreen.routeName);
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<Audio>();
    final urlList = url.split('/');

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          store.currentUrl.isNotEmpty
              ? store.getCurrentMusic().title
              : urlList[urlList.length - 1],
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 18.0,
            color: Color(0xff500D5B),
          ),
        ),
        TextButton(
          text: 'Add to',
          onPressed: () => Navigator.pushNamed(
            context,
            AddMusicPlaylists.routeName,
            arguments: url ?? context.read<Audio>().currentUrl,
          ),
        ),
        TextButton(
          text: 'Set as ringtone',
          onPressed: () {},
        ),
        TextButton(
          text: 'Sleep timer',
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, SleepTimerScreen.routeName);
          },
        ),
        TextButton(
          text: 'Delete',
          onPressed: () {
            Navigator.pop(context);
            _showDeleteDialog(context);
          },
        ),
        TextButton(
          text: 'Detail',
          onPressed: () {},
        ),
        TextButton(
          text: 'Edit',
          onPressed: () async {
            if (url.isNotEmpty) {
              final store = context.read<Audio>();
              store.setCurrentUrl(url: url, sync: false);
              store.setEditHome(true);
            }
            Navigator.popAndPushNamed(context, EditMusicScreen.routeName);
          },
        ),
      ],
    );
  }
}
