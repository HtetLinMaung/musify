import 'package:flutter/material.dart';
import 'package:music_player/components/selection_list.dart';
import 'package:music_player/models/item.dart';
import 'package:music_player/models/playlist.dart';
import 'package:music_player/models/playlist_music.dart';
import 'package:music_player/database.dart';
import 'package:music_player/screens/player_screen.dart';

class AddMusicPlaylists extends StatefulWidget {
  static const routeName = 'AddMusicPlaylists';

  @override
  _AddMusicPlaylistsState createState() => _AddMusicPlaylistsState();
}

class _AddMusicPlaylistsState extends State<AddMusicPlaylists> {
  List<Playlist> _playlists = [];

  @override
  void initState() {
    super.initState();
    setPlaylists();
  }

  void setPlaylists() async {
    var playlists = await getAllPlaylists();
    setState(() {
      _playlists = playlists;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SelectionList(
      hideSubTitle: true,
      items: List.generate(_playlists.length, (i) {
        return Item(
          checked: false,
          title: _playlists[i].name,
          subTitle: '',
          key: _playlists[i].id.toString(),
        );
      }),
      onPressedSave: (checkedList) async {
        String currentUrl = ModalRoute.of(context).settings.arguments;
        final playlistMusics = await getAllPlaylistMusics();
        checkedList.forEach((item) {
          var shouldAdd = true;
          int playlistId = int.parse(item.key);
          for (var playlistMusic in playlistMusics) {
            if (playlistMusic.url == currentUrl &&
                playlistId == playlistMusic.playlistId) {
              shouldAdd = false;
              break;
            }
          }
          if (shouldAdd) {
            insertMusicByPlaylist(
                playlistMusic: PlaylistMusic(
              playlistId: playlistId,
              url: currentUrl,
            ));
          }
        });

        Navigator.pushNamed(
          context,
          PlayerScreen.routeName,
        );
      },
    );
  }
}
