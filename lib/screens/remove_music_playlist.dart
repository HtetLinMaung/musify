import 'package:flutter/material.dart';
import 'package:music_player/components/selection_list.dart';
import 'package:music_player/models/item.dart';
import 'package:music_player/models/playlist_music.dart';
import 'package:music_player/database.dart';
import 'package:music_player/screens/playlist_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:music_player/store/audio.dart';

class RemoveMusicPlaylists extends StatefulWidget {
  static const routeName = 'RemoveMusicPlaylists';

  @override
  _RemoveMusicPlaylistsState createState() => _RemoveMusicPlaylistsState();
}

class _RemoveMusicPlaylistsState extends State<RemoveMusicPlaylists> {
  List<PlaylistMusic> _playlistMusics = [];

  @override
  void initState() {
    super.initState();
    _getMusicByPlaylist();
  }

  void _getMusicByPlaylist() async {
    final store = context.read<Audio>();
    var playlistMusics = await getMusicByPlaylist(store.playlist.id);

    setState(() {
      _playlistMusics = playlistMusics;
    });
  }

  String getTitle(String url) {
    final urlList = url.split('/');
    return urlList[urlList.length - 1];
  }

  @override
  Widget build(BuildContext context) {
    return SelectionList(
      hideSubTitle: true,
      items: List.generate(_playlistMusics.length, (i) {
        return Item(
          checked: false,
          title: getTitle(_playlistMusics[i].url),
          subTitle: '',
          key: _playlistMusics[i].id.toString(),
        );
      }),
      onPressedSave: (checkedList) async {
        checkedList.forEach((item) {
          deleteMusicById(
            id: int.parse(item.key),
          );
        });

        Navigator.pushNamed(
          context,
          PlaylistDetailScreen.routeName,
        );
      },
    );
  }
}
