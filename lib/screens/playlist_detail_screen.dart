import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music_player/components/modal_sheet.dart';
import 'package:music_player/components/music_tile.dart';
import 'package:music_player/components/playlist_detail/playlist_music_list.dart';
import 'package:music_player/components/text_button.dart';
import 'package:music_player/constant.dart';
import 'package:music_player/database.dart';
import 'package:music_player/models/playlist_music.dart';
import 'package:music_player/screens/add_playlist_musics.dart';
import 'package:music_player/screens/edit_playlist_screen.dart';
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
  List<PlaylistMusic> _playlistMusic;

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
        play: Play.PLAYLIST,
        title: music.title,
        iconPressed: () async {
          setState(() {
            music.favorite = !music.favorite;
            store.setMusicList(store.musicList.map((ele) {
              if (music.url == ele.url) {
                ele.favorite = music.favorite;
              }
              return ele;
            }).toList());

            _musics = _musics.map((ele) {
              MusicTile musicTile = ele;
              if (musicTile.musicUrl == music.url) {
                if (music.favorite) {
                  return MusicTile(
                    title: musicTile.title,
                    play: musicTile.play,
                    iconPressed: musicTile.iconPressed,
                    musicUrl: musicTile.musicUrl,
                    favIconColor: kFavColor,
                  );
                } else {
                  return MusicTile(
                    title: musicTile.title,
                    play: musicTile.play,
                    iconPressed: musicTile.iconPressed,
                    musicUrl: musicTile.musicUrl,
                    favIconColor: Color(0xff3C225C),
                  );
                }
              } else {
                return ele;
              }
            }).toList();

            if (music.favorite) {
              insertFavorite(
                music: music,
              );
            } else {
              deleteFavorite(url: music.url);
            }
          });
        },
        musicUrl: music.url,
        favIconColor: !music.favorite ? Color(0xff3C225C) : kFavColor,
      );
    });
  }

  void _getMusicByPlaylist() async {
    final store = context.read<Audio>();
    var musics = await getMusicByPlaylist(store.playlist.id);
    _playlistMusic = musics;

    setState(() {
      _musics = generateWidgetList(musics);
    });
  }

  Future<void> _showDeleteDialog() async {
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
                  onPressed: () {
                    final store = context.read<Audio>();
                    deletePlaylist(playlistId: store.playlist.id);
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, PlaylistScreen.routeName);
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
                child: Hero(
                  tag: 'image',
                  child: Image.file(
                    File(playlist.filePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return ModalSheet(
                          height: 200,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              TextButton(
                                text: 'Add to Playlist',
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(
                                    context,
                                    AddPlaylistMusics.routeName,
                                  );
                                },
                              ),
                              TextButton(
                                text: 'Edit',
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(
                                    context,
                                    EditPlaylistScreen.routeName,
                                  );
                                },
                              ),
                              TextButton(
                                text: 'Delete',
                                onPressed: () {
                                  Navigator.pop(context);
                                  _showDeleteDialog();
                                },
                              ),
                            ],
                          ),
                        );
                      });
                },
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
        onPressed: () {
          final store = context.read<Audio>();
          store.setPlay(Play.PLAYLIST);

          if (_playlistMusic.isNotEmpty)
            store.stopAndPlay(_playlistMusic[0].url);
        },
        backgroundColor: kPlayerActiveColor,
      ),
    );
  }
}
