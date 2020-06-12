import 'package:flutter/material.dart';
import 'package:music_player/components/music_list.dart';
import 'package:music_player/constant.dart';
import 'package:music_player/screens/home_screen.dart';
import 'package:music_player/screens/selection_screen.dart';
import 'package:provider/provider.dart';
import 'package:music_player/store/audio.dart';
import 'package:music_player/components/shuffle_row.dart';
import 'package:music_player/components/floating_button.dart';
import 'package:music_player/components/bottom_navbar.dart';
import 'selection_screen.dart';

class FavoriteScreen extends StatefulWidget {
  static const routeName = 'FavoriteScreen';

  @override
  FavoriteScreenState createState() => FavoriteScreenState();
}

class FavoriteScreenState extends State<FavoriteScreen> {
  MusicView _view = MusicView.LIST;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<Audio>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushNamed(context, HomeScreen.routeName),
        ),
        title: Text('Favourites'),
        backgroundColor: kBackgroundColor,
        elevation: 0,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, SelectionScreen.routeName);
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          ShuffleRow(
            view: _view,
            viewHandler: () {},
            favorite: false,
            favoriteShuffle: true,
          ),
          MusicList(
            favPlay: true,
            musics: store.musicList.where((music) => music.favorite).toList(),
          ),
        ],
      ),
      floatingActionButton: store.currentUrl.isEmpty ? null : FloatingButton(),
      bottomNavigationBar: store.currentUrl.isEmpty ? null : BottomNavbar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
