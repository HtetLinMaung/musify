import 'package:flutter/material.dart';

class AlbumCorver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: CircleAvatar(
        radius: 120.0,
        backgroundImage: AssetImage('assets/images/headphone.jpeg'),
      ),
    );
  }
}
