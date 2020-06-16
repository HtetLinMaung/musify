import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music_player/components/music_tile.dart';
import 'package:music_player/components/playlist_detail/playlist_music_list.dart';
import 'package:music_player/constant.dart';
import 'package:music_player/database.dart';
import 'package:music_player/models/playlist_music.dart';
import 'package:music_player/screens/playlist_screen.dart';
import 'package:music_player/store/audio.dart';
import 'package:provider/provider.dart';

class PlaylistDetailScreen extends StatefulWidget {
  static const routeName = 'PlaylistDetail';

  @override
  _PlaylistDetailScreenState createState() => _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends State<PlaylistDetailScreen> {
  List<Widget> _musics = [];

  @override
  void initState() {
    super.initState();
    _getMusicByPlaylist();
  }

  List<Widget> generateWidgetList(List<PlaylistMusic> musics) {
    final store = context.read<Audio>();

    return List.generate(musics.length, (i) {
      final music =
          store.musicList.firstWhere((music) => music.url == musics[i].url);
      return MusicTile(
        title: music.title,
        iconPressed: () {},
        musicUrl: music.url,
        favIconColor: !music.favorite ? Color(0xff3C225C) : kFavColor,
      );
    });
  }

  void _getMusicByPlaylist() async {
    final store = context.read<Audio>();
    var musics = await getMusicByPlaylist(store.playlist.id);

    setState(() {
      _musics = generateWidgetList(musics);
    });
  }

  @override
  Widget build(BuildContext context) {
    final playlist = context.watch<Audio>().playlist;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () =>
                  Navigator.pushNamed(context, PlaylistScreen.routeName),
            ),
            elevation: 5,
            backgroundColor: kBackgroundColor,
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(35),
                bottomRight: Radius.circular(35),
              ),
            ),
            pinned: true,
            expandedHeight: 300.0,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                playlist.name,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              background: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35),
                ),
                child: Image.file(
                  File(playlist.filePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
              ),
            ],
          ),
          PlaylistMusicList(
            musics: _musics,
            playlist: playlist,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.play_arrow,
          color: Colors.white,
        ),
        onPressed: () {},
        backgroundColor: kPlayerActiveColor,
      ),
    );
  }
}
