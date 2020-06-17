import 'package:flutter/material.dart';
import 'package:music_player/constant.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_player/screens/playlist_screen.dart';
import 'shuffle_button.dart';
import 'package:music_player/components/shuffle_button.dart';
import 'package:music_player/screens/favorite_screen.dart';

class ShuffleRow extends StatelessWidget {
  final MusicView view;
  final Function viewHandler;
  final bool favorite;
  final Play play;

  ShuffleRow(
      {@required this.view,
      @required this.viewHandler,
      this.favorite = true,
      this.play = Play.NONE});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: <Widget>[
          ShuffleButton(
            play: play,
          ),
          Expanded(
            child: Text(''),
          ),
          favorite
              ? IconButton(
                  icon: Icon(
                    Icons.playlist_add,
                    color: kPlayerIconColor,
                  ),
                  onPressed: () =>
                      Navigator.pushNamed(context, PlaylistScreen.routeName),
                )
              : Text(''),
          favorite
              ? IconButton(
                  icon: Icon(
                    Icons.favorite,
                    size: 16,
                    color: kPlayerIconColor,
                  ),
                  onPressed: () =>
                      Navigator.pushNamed(context, FavoriteScreen.routeName),
                )
              : Text(''),
          IconButton(
            icon: Icon(
              view == MusicView.LIST
                  ? FontAwesomeIcons.thLarge
                  : FontAwesomeIcons.list,
              size: 14,
              color: kPlayerIconColor,
            ),
            onPressed: viewHandler,
          )
        ],
      ),
    );
  }
}
