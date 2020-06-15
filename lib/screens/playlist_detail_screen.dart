import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music_player/constant.dart';
import 'package:music_player/models/playlist.dart';

class PlaylistDetailScreen extends StatefulWidget {
  static const routeName = 'PlaylistDetail';

  @override
  _PlaylistDetailScreenState createState() => _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends State<PlaylistDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final Playlist playlist = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            elevation: 5,
            backgroundColor: kBackgroundColor,
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35),
                    bottomRight: Radius.circular(35))),
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
                child: Image.file(
                  File(playlist.filePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                color: kBackgroundColor,
                height: 100,
              ),
              Container(
                color: kBackgroundColor,
                height: 100,
              ),
              Container(
                color: kBackgroundColor,
                height: 100,
              ),
              Container(
                color: kBackgroundColor,
                height: 100,
              ),
              Container(
                color: kBackgroundColor,
                height: 100,
              ),
              Container(
                color: kBackgroundColor,
                height: 100,
              ),
              Container(
                color: kBackgroundColor,
                height: 100,
              ),
              Container(
                color: kBackgroundColor,
                height: 100,
              ),
              Container(
                color: kBackgroundColor,
                height: 100,
              ),
              Container(
                color: kBackgroundColor,
                height: 100,
              ),
            ]),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.play_arrow,
          color: Colors.white,
        ),
        onPressed: () {},
        backgroundColor: kPlayerActiveColor,
      ),
    );
  }
}
