import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music_player/constant.dart';
import 'package:music_player/components/shuffle_row.dart';
import 'package:music_player/store/audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:music_player/components/music_list.dart';
import 'package:music_player/models/music.dart';
import 'package:provider/provider.dart';
import 'package:music_player/components/floating_button.dart';
import 'package:music_player/components/bottom_navbar.dart';
import 'package:move_to_background/move_to_background.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = 'HomeScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Music> _musics = [];
  MusicView _view = MusicView.LIST;

  @override
  void initState() {
    super.initState();

    _getLocalMusic();
  }

  void _getLocalMusic() async {
    if (await Permission.storage.request().isGranted) {
      final dir = Directory('/storage/emulated/0/');
      final musicUrlList = (await dir.list(recursive: true).toList())
          .where((entity) => entity.path.endsWith('.mp3'))
          .toList();

      setState(() {
        _musics = musicUrlList.map((entity) {
          final pathArray = entity.path.split('/');
          final title = pathArray[pathArray.length - 1];
          return Music(url: entity.path, title: title);
        }).toList();

        _musics.sort((a, b) {
          return a.title.toLowerCase().compareTo(b.title.toLowerCase());
        });

        Provider.of<Audio>(context, listen: false).setMusicList(_musics);
      });
    }
  }

  void _viewHandler() {
    setState(() {
      switch (_view) {
        case MusicView.ALBUMN:
          _view = MusicView.LIST;
          break;
        default:
          _view = MusicView.ALBUMN;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        MoveToBackground.moveTaskToBack();
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  autofocus: false,
                  onChanged: (v) {
                    final store = context.read<Audio>();
                    setState(() {
                      if (v.length > 0) {
                        _musics = store.musicList
                            .where((music) => music.title
                                .contains(RegExp(v, caseSensitive: false)))
                            .toList();
                      } else {
                        _musics = store.musicList;
                      }
                    });
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: kInputColor,
                    ),
                    hintText: 'Song or Artist',
                    fillColor: kInputFillColor,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(
                          style: BorderStyle.none,
                          width: 0,
                        )),
                    hintStyle: TextStyle(
                      color: kInputColor,
                    ),
                  ),
                ),
              ),
              ShuffleRow(
                view: _view,
                viewHandler: _viewHandler,
              ),
              MusicList(
                musics: _musics,
              ),
            ],
          ),
        ),
        floatingActionButton:
            context.watch<Audio>().currentUrl.isEmpty ? null : FloatingButton(),
        bottomNavigationBar:
            context.watch<Audio>().currentUrl.isEmpty ? null : BottomNavbar(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
