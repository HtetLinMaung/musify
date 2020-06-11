import 'package:flutter/material.dart';
import 'package:music_player/models/music.dart';
import 'music_tile.dart';
import 'package:music_player/constant.dart';
import 'package:music_player/database.dart';
import 'package:provider/provider.dart';
import 'package:music_player/store/audio.dart';

class MusicList extends StatefulWidget {
  final List<Music> musics;
  final bool favPlay;

  MusicList({@required this.musics, this.favPlay = false});

  @override
  _MusicListState createState() => _MusicListState();
}

class _MusicListState extends State<MusicList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: widget.musics.length,
          itemBuilder: (context, i) {
            return MusicTile(
              favPlay: widget.favPlay,
              title: widget.musics[i].title,
              musicUrl: widget.musics[i].url,
              favIconColor:
                  !widget.musics[i].favorite ? Color(0xff3C225C) : kFavColor,
              iconPressed: () {
                final store = context.read<Audio>();

                setState(() {
                  widget.musics[i].favorite = !widget.musics[i].favorite;
                  store.setMusicList(store.musicList.map((music) {
                    if (music.url == widget.musics[i].url) {
                      music.favorite = widget.musics[i].favorite;
                    }
                    return music;
                  }).toList());

                  if (widget.musics[i].favorite) {
                    insert(music: widget.musics[i], table: 'favorites');
                  } else {
                    delete(url: widget.musics[i].url, table: 'favorites');
                  }
                });
              },
            );
          },
        ),
      ),
    );
  }
}
