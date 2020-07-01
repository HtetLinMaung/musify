import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:music_player/components/edit_albumn_layout.dart';
import 'package:music_player/database.dart';
import 'package:music_player/models/music.dart';
import 'package:music_player/models/music_image.dart';
import 'package:music_player/models/playlist_music.dart';
import 'package:music_player/screens/home_screen.dart';
import 'package:music_player/screens/player_screen.dart';
import 'package:music_player/store/audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class EditMusicScreen extends StatefulWidget {
  static const routeName = 'EditMusicScreen';

  @override
  _EditMusicScreenState createState() => _EditMusicScreenState();
}

class _EditMusicScreenState extends State<EditMusicScreen> {
  final picker = ImagePicker();
  final _musicNameController = TextEditingController();
  final _albumNameController = TextEditingController();
  final _artistNameController = TextEditingController();
  String _musicUrl = '';
  List<MusicImage> _musicImages = [];
  File _image = File('');

  @override
  void initState() {
    super.initState();
    final store = context.read<Audio>();
    final music = store.getCurrentMusic();
    _musicNameController.text = music.title;
    _musicUrl = music.url;
    _getImage(music.url);
  }

  void _getImage(String musicUrl) async {
    _musicImages = await getImageByMusic(musicUrl);
    if (_musicImages.isNotEmpty) {
      _albumNameController.text = _musicImages[0].albumName;
      _artistNameController.text = _musicImages[0].artistName;

      setState(() {
        _image = File(_musicImages[0].imageUrl);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return EditAlbumLayout(
      controller2: _albumNameController,
      appBarTitle: 'Edit Music',
      backPressed: () {
        final store = context.read<Audio>();
        if (store.editHome) {
          store.setEditHome(false);
          if (!AudioService.running)
            store.setCurrentUrl(url: '', sync: false);
          else {
            final mediaItem = AudioService.currentMediaItem;
            store.setCurrentUrl(url: mediaItem.id, sync: false);
          }
          Navigator.pushNamed(context, HomeScreen.routeName);
        } else {
          Navigator.pushNamed(context, PlayerScreen.routeName);
        }
      },
      controller: _musicNameController,
      hintText: 'Edit music name',
      hintText2: 'Edit album name',
      hintText3: 'Edit artist name',
      controller3: _artistNameController,
      image: _image,
      onAccepted: () async {
        final store = context.read<Audio>();

        var musicUrlList = _musicUrl.split('/');
        musicUrlList[musicUrlList.length - 1] = _musicNameController.text;
        var musicUrl = musicUrlList.join('/');
        store.setCurrentUrl(url: musicUrl);
        store.setCurrentImageUrl(_image.path);
        store.setMusicList(store.musicList.map((music) {
          if (music.url == _musicUrl) {
            return Music(
              title: _musicNameController.text,
              url: musicUrl,
              favorite: music.favorite,
            );
          } else {
            return music;
          }
        }).toList());
        File(_musicUrl).rename(musicUrl);
        var musicItem = AudioService.currentMediaItem;
        AudioService.customAction(
          'updateMediaItem',
          {
            'id': musicUrl,
            'title': musicUrlList[musicUrlList.length - 1],
            'duration': musicItem.duration.inSeconds,
            'album': musicItem.album,
            'artUri': Uri.file(_image.path).toString()
          },
        );

        var musicImage = MusicImage(
          imageUrl: _image.path,
          musicUrl: musicUrl,
          albumName: _albumNameController.text,
          artistName: _artistNameController.text,
        );

        if (_musicImages.isEmpty) {
          insertImageByMusic(
            musicImage: musicImage,
          );
        } else {
          updateImageByMusic(
            musicImage: MusicImage(
              id: _musicImages[0].id,
              imageUrl: _image.path,
              musicUrl: musicUrl,
              albumName: _albumNameController.text,
              artistName: _artistNameController.text,
            ),
            musicUrl: _musicUrl,
          );
        }

        var favoriteMusics = await getAllFavorites();
        for (var music in favoriteMusics) {
          if (music.url == _musicUrl) {
            updateFavoriteByUrl(
                music: Music(
                  title: music.title,
                  url: musicUrl,
                  favorite: music.favorite,
                  id: music.id,
                ),
                url: _musicUrl);
            break;
          }
        }
        var playlistMusics = await getPlaylistMusicByUrl(url: _musicUrl);
        if (playlistMusics.isNotEmpty) {
          for (var playlistMusic in playlistMusics) {
            updatePlaylistMusicByUrl(
                playlistMusic: PlaylistMusic(
                  playlistId: playlistMusic.playlistId,
                  url: musicUrl,
                  id: playlistMusic.id,
                ),
                url: _musicUrl);
          }
        }

        if (!store.editHome)
          Navigator.pushNamed(context, PlayerScreen.routeName);
        else {
          store.setEditHome(false);
          Navigator.pushNamed(context, HomeScreen.routeName);
        }
      },
      onTapImage: () async {
        if (await Permission.storage.request().isGranted) {
          final pickedFile = await picker.getImage(source: ImageSource.gallery);

          setState(() {
            _image = File(pickedFile.path);
          });
        }
      },
    );
  }
}
