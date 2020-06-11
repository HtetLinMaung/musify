import 'package:flutter/material.dart';
import 'text_button.dart';
import 'package:provider/provider.dart';
import 'package:music_player/store/audio.dart';

class EditColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          context.watch<Audio>().getCurrentMusic().title,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 18.0,
            color: Color(0xff500D5B),
          ),
        ),
        TextButton(
          text: 'Add to',
          onPressed: () {},
        ),
        TextButton(
          text: 'Set as ringtone',
          onPressed: () {},
        ),
        TextButton(
          text: 'Delete',
          onPressed: () {},
        ),
        TextButton(
          text: 'Detail',
          onPressed: () {},
        ),
        TextButton(
          text: 'Edit',
          onPressed: () {},
        ),
      ],
    );
  }
}
