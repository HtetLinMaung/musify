import 'package:flutter/material.dart';
import 'package:music_player/constant.dart';
import 'package:music_player/models/playlist.dart';
import 'package:music_player/screens/add_playlist_musics.dart';

class PlaylistMusicList extends StatelessWidget {
  PlaylistMusicList({
    Key key,
    this.musics,
    this.playlist,
  }) : super(key: key);

  final List<Widget> musics;
  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(musics.isEmpty
          ? [
              Padding(
                padding: const EdgeInsets.all(60.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    OutlineButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: Text(
                        'Add Musics',
                        style: TextStyle(
                          color: kInputColor,
                        ),
                      ),
                      onPressed: () => Navigator.pushNamed(
                        context,
                        AddPlaylistMusics.routeName,
                      ),
                    ),
                  ],
                ),
              ),
            ]
          : musics),
    );
  }
}
