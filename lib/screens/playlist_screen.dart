import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_player/components/modal_sheet.dart';
import 'package:music_player/constant.dart';
import 'package:music_player/models/playlist.dart';
import 'home_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:music_player/database.dart';

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

  void clear() {
    _image = File('');
    _playlistName = '';
  }

  void getPlaylists() async {
    var playlist = await getAllPlaylists();
    setState(() {
      _playlists = playlist;
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
                                      child: Container(
                                        width: 150,
                                        height: 160,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(35),
                                          image: DecorationImage(
                                            image: FileImage(_image),
                                            fit: BoxFit.fill,
                                          ),
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
                                    onPressed: () {
                                      var playlist = Playlist(
                                        filePath: _image.path,
                                        name: _playlistName,
                                      );
                                      insertPlaylist(playlist: playlist);
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
            child: ListView.builder(
              itemCount: _playlists.length,
              itemBuilder: (context, i) {
                return Column(
                  children: <Widget>[
                    Card(
                      margin: EdgeInsets.all(30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35),
                      ),
                      color: kInActiveColor,
                      child: Container(
                        height: 260,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35),
                          image: DecorationImage(
                            image: FileImage(
                              File(_playlists[i].filePath),
                            ),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Center(
                          child: FaIcon(
                            FontAwesomeIcons.music,
                            color: _playlists[i].filePath.isEmpty
                                ? Colors.transparent
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
