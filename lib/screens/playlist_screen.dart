import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_player/components/modal_sheet.dart';
import 'package:music_player/constant.dart';
import 'package:music_player/models/playlist.dart';
import 'package:music_player/screens/playlist_detail_screen.dart';
import 'package:music_player/store/audio.dart';
import 'home_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:music_player/database.dart';
import 'package:provider/provider.dart';

class PlaylistScreen extends StatefulWidget {
  static const routeName = 'PlaylistScreen';

  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  final picker = ImagePicker();
  File _image = File('');
  String _playlistName = '';
  List<Playlist> _playlists = [];
  List<int> _counts = [];

  void clear() {
    _image = File('');
    _playlistName = '';
  }

  void getPlaylists() async {
    var playlists = await getAllPlaylists();

    _counts = [];
    for (var playlist in playlists) {
      var count = (await getMusicByPlaylist(playlist.id)).length;
      _counts.add(count);
    }

    setState(() {
      _playlists = playlists;
    });
  }

  @override
  void initState() {
    super.initState();
    getPlaylists();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushNamed(context, HomeScreen.routeName),
        ),
        title: Text('Playlists'),
        backgroundColor: kBackgroundColor,
        elevation: 0,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_to_photos),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (context, setModalState) {
                        return ModalSheet(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Create Playlist',
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Color(0xff500D5B),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Enter Playlist name',
                                  style: TextStyle(
                                    color: Color(0xff500D5B),
                                  ),
                                ),
                              ),
                              TextField(
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
                                onChanged: (v) {
                                  _playlistName = v;
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Pick Album Corver',
                                  style: TextStyle(
                                    color: Color(0xff500D5B),
                                  ),
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(35),
                                    ),
                                    color: kInActiveColor,
                                    child: InkWell(
                                      splashColor: Colors.purple.withAlpha(30),
                                      onTap: () async {
                                        if (await Permission.storage
                                            .request()
                                            .isGranted) {
                                          final pickedFile =
                                              await picker.getImage(
                                                  source: ImageSource.gallery);

                                          setModalState(() {
                                            _image = File(pickedFile.path);
                                          });
                                        }
                                      },
                                      child: Hero(
                                        tag: 'image',
                                        child: Container(
                                          width: 150,
                                          height: 160,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(35),
                                            image: _image.existsSync()
                                                ? DecorationImage(
                                                    image: FileImage(_image),
                                                    fit: BoxFit.fill,
                                                  )
                                                : null,
                                          ),
                                          child: Center(
                                            child: FaIcon(
                                              FontAwesomeIcons.music,
                                              color: _image.existsSync()
                                                  ? Colors.transparent
                                                  : Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // #A376AF
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  FlatButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(35),
                                    ),
                                    color: Color(0xffF06B94),
                                    child: Text('Cancel'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      clear();
                                    },
                                  ),
                                  FlatButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(35),
                                    ),
                                    color: Color(0xffA376AF),
                                    child: Text('Ok'),
                                    onPressed: () async {
                                      var playlist = Playlist(
                                        filePath: _image.path,
                                        name: _playlistName,
                                      );
                                      await insertPlaylist(playlist: playlist);
                                      getPlaylists();
                                      Navigator.pop(context);
                                      clear();
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    );
                  });
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              childAspectRatio: 0.74,
              children: List.generate(_playlists.length, (i) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          context.read<Audio>().setPlaylist(_playlists[i]);
                          Navigator.pushNamed(
                            context,
                            PlaylistDetailScreen.routeName,
                          );
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          color: kInActiveColor,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              image: _playlists[i].filePath.isNotEmpty
                                  ? DecorationImage(
                                      image: FileImage(
                                        File(_playlists[i].filePath),
                                      ),
                                      fit: BoxFit.fill,
                                    )
                                  : null,
                            ),
                            child: Center(
                              child: FaIcon(
                                FontAwesomeIcons.music,
                                color: _playlists[i].filePath.isNotEmpty
                                    ? Colors.transparent
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        bottom: 5.0,
                        top: 15.0,
                      ),
                      child: Text(
                        _playlists[i].name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18,
                          color: kMainTextColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        '${_counts[i]} songs',
                        style: TextStyle(
                          color: kInputColor,
                        ),
                      ),
                    )
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
