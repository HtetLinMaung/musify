import 'package:flutter/material.dart';
import 'package:music_player/components/edit_column.dart';
import 'package:music_player/components/modal_sheet.dart';
import 'package:music_player/constant.dart';
import 'package:music_player/screens/player_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_player/store/audio.dart';
import 'package:provider/provider.dart';

class MusicTile extends StatelessWidget {
  const MusicTile(
      {Key key,
      @required this.title,
      this.subtitle,
      this.musicUrl,
      @required this.iconPressed,
      this.favIconColor,
      this.play = Play.NONE})
      : super(key: key);

  final String title;
  final String subtitle;
  final String musicUrl;
  final Function iconPressed;
  final Color favIconColor;
  final Play play;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return ModalSheet(
              child: EditColumn(
                url: musicUrl,
              ),
              height: 300,
            );
          },
        );
      },
      leading: CircleAvatar(
        backgroundColor: Color(0xff3C225C),
        child: FaIcon(
          FontAwesomeIcons.music,
          size: 12.0,
          color: Color(0xffBD96D8),
        ),
      ),
      title: Text(
        title,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
      ),
      subtitle: Text('Unknown Artist | Unknown Album'),
      trailing: IconButton(
        icon: Icon(
          Icons.favorite,
          color: favIconColor,
        ),
        onPressed: iconPressed,
      ),
      onTap: () {
        final store = context.read<Audio>();

        store.setPlay(play);
        store.stopAndPlay(musicUrl);
        Navigator.pushNamed(context, PlayerScreen.routeName);
      },
    );
  }
}
