import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:music_player/constant.dart';
import 'package:music_player/database.dart';
import 'package:music_player/store/audio.dart';
import 'package:music_player/components/modal_sheet.dart';
import 'package:music_player/components/edit_column.dart';

class PlayerOption extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final store = context.watch<Audio>();

    return Container(
      decoration: BoxDecoration(
        color: Color(0xff260F42),
        borderRadius: BorderRadius.circular(30.0),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 16.0,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: 18.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return ModalSheet(
                    child: EditColumn(),
                    height: 300,
                  );
                },
              );
            },
            icon: Icon(
              Icons.more_horiz,
              color: kPlayerIconColor,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.playlist_play,
              color: kPlayerIconColor,
            ),
          ),
          IconButton(
            onPressed: () {
              final store = context.read<Audio>();
              store.getCurrentMusic().favorite =
                  !store.getCurrentMusic().favorite;
              final music = store.getCurrentMusic();
              if (music.favorite) {
                insertFavorite(
                  music: music,
                );
              } else {
                deleteFavorite(
                  url: music.url,
                );
              }
            },
            icon: Icon(
              Icons.favorite,
              color: store.currentUrl.isNotEmpty &&
                      store.getCurrentMusic().favorite
                  ? kFavColor
                  : kPlayerIconColor,
            ),
          ),
        ],
      ),
    );
  }
}
