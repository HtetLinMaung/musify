import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_player/constant.dart';
import 'package:music_player/database.dart';
import 'package:music_player/models/playlist.dart';
import 'package:music_player/screens/playlist_detail_screen.dart';
import 'package:music_player/store/audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditPlaylistScreen extends StatefulWidget {
  static const routeName = 'EditPlaylistScreen';

  @override
  _EditPlaylistScreenState createState() => _EditPlaylistScreenState();
}

class _EditPlaylistScreenState extends State<EditPlaylistScreen> {
  final picker = ImagePicker();
  final _playlistController = TextEditingController();
  File _image = File('');

  @override
  void initState() {
    super.initState();
    final store = context.read<Audio>();
    setState(() {
      _image = File(store.playlist.filePath);
      _playlistController.text = store.playlist.name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () =>
              Navigator.pushNamed(context, PlaylistDetailScreen.routeName),
        ),
        elevation: 0,
        backgroundColor: kBackgroundColor,
        title: Text('Edit Playlist'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.check,
            ),
            onPressed: () {
              final store = context.read<Audio>();
              final playlist = Playlist(
                id: store.playlist.id,
                filePath: _image.path,
                name: _playlistController.text,
              );
              updatePlaylist(
                playlist: playlist,
              );
              store.setPlaylist(playlist);
              Navigator.pushNamed(context, PlaylistDetailScreen.routeName);
            },
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Card(
            margin: EdgeInsets.symmetric(horizontal: 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35),
            ),
            color: kInActiveColor,
            child: InkWell(
              splashColor: Colors.purple.withAlpha(30),
              onTap: () async {
                if (await Permission.storage.request().isGranted) {
                  final pickedFile =
                      await picker.getImage(source: ImageSource.gallery);

                  setState(() {
                    _image = File(pickedFile.path);
                  });
                }
              },
              child: Container(
                height: 260,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35),
                  image: DecorationImage(
                    image: FileImage(_image),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Center(
                  child: FaIcon(
                    FontAwesomeIcons.music,
                    color:
                        _image.existsSync() ? Colors.transparent : Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 50.0, vertical: 30.0),
            child: TextField(
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(
                    style: BorderStyle.none,
                    width: 0,
                  ),
                ),
                hintText: 'Enter playlist name',
              ),
              controller: _playlistController,
            ),
          ),
        ],
      ),
    );
  }
}
