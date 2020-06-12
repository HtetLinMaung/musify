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
import 'package:music_player/database.dart';
import 'package:music_player/components/search_field.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = 'HomeScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MusicView _view = MusicView.LIST;
  String _search = '';

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
      final favorites = await getData(table: 'favorites');

      setState(() {
        final musics = musicUrlList.map((entity) {
          final pathArray = entity.path.split('/');
          final title = pathArray[pathArray.length - 1];

          var favFlag = false;
          for (var favorite in favorites) {
            if (favorite.url == entity.path) {
              favFlag = true;
              break;
            }
          }
          return Music(
            url: entity.path,
            title: title,
            favorite: favFlag,
          );
        }).toList();

        musics.sort((a, b) {
          return a.title.toLowerCase().compareTo(b.title.toLowerCase());
        });

        Provider.of<Audio>(context, listen: false).setMusicList(musics);
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

  List<Music> filterMusics(String v) {
    final store = context.watch<Audio>();
    if (v.length > 0) {
      return store.musicList
          .where(
              (music) => music.title.contains(RegExp(v, caseSensitive: false)))
          .toList();
    } else {
      return store.musicList;
    }
  }

  void _textChangeHandler(String v) {
    setState(() {
      _search = v;
    });
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<Audio>();

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
              SearchField(
                onChanged: _textChangeHandler,
              ),
              ShuffleRow(
                view: _view,
                viewHandler: _viewHandler,
              ),
              MusicList(
                musics: filterMusics(_search),
              ),
            ],
          ),
        ),
        floatingActionButton:
            store.currentUrl.isEmpty ? null : FloatingButton(),
        bottomNavigationBar: store.currentUrl.isEmpty ? null : BottomNavbar(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
