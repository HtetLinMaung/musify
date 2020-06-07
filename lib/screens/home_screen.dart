import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music_player/constant.dart';
import 'package:music_player/store/audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:music_player/components/music_tile.dart';
import 'package:music_player/models/music.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = 'HomeScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Music> _musics = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: _musics.length,
                  itemBuilder: (context, i) {
                    return MusicTile(
                      title: _musics[i].title,
                      musicUrl: _musics[i].url,
                      favIconColor: !_musics[i].favorite
                          ? Color(0xff3C225C)
                          : Color(0xffFF16CD),
                      iconPressed: () {
                        setState(() {
                          _musics[i].favorite = !_musics[i].favorite;
                        });
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
