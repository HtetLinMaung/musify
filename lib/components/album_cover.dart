import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music_player/constant.dart';
import 'package:music_player/store/audio.dart';
import 'package:provider/provider.dart';

class AlbumCorver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final store = context.watch<Audio>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 50),
      child: CircleAvatar(
        radius: 130,
        backgroundImage: store.currentImageUrl.isEmpty
            ? AssetImage('assets/images/headphone.jpeg')
            : FileImage(
                File(store.currentImageUrl),
              ),
        backgroundColor: kPlayerActiveColor,
      ),
    );
  }
}
