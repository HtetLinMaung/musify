import 'package:flutter/material.dart';
import 'package:music_player/components/selection_list.dart';
import 'package:music_player/models/item.dart';
import 'package:music_player/models/playlist.dart';
import 'package:music_player/models/playlist_music.dart';
import 'package:music_player/screens/playlist_detail_screen.dart';
import 'package:music_player/store/audio.dart';
import 'package:provider/provider.dart';
import 'package:music_player/database.dart';

class AddPlaylistMusics extends StatefulWidget {
  static const routeName = 'AddPlaylistMusics';

  @override
  _AddPlaylistMusicsState createState() => _AddPlaylistMusicsState();
}

class _AddPlaylistMusicsState extends State<AddPlaylistMusics> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<Audio>();
    final Playlist playlist = ModalRoute.of(context).settings.arguments;

    return SelectionList(
      items: List.generate(store.musicList.length, (i) {
        return Item(
          checked: false,
          title: store.musicList[i].title,
          subTitle: 'Unknown Artist | Unknown Albumn',
          key: store.musicList[i].url,
        );
      }),
      onPressedSave: (checkedList) async {
        final store = context.read<Audio>();
        var playlistMusics = await getMusicByPlaylist(store.playlist.id);

        // checkedList.forEach((item) {
          
        //   insertMusicByPlaylist(
        //     playlistMusic: PlaylistMusic(
        //       playlistId: playlist.id,
        //       url: item.key,
        //     ),
        //   );
        // });
        for (var item in checkedList) {
          for (var music in playlistMusics) {
            
          }
        }
        Navigator.pushNamed(
          context,
          PlaylistDetailScreen.routeName,
        );
      },
    );
  }
}
