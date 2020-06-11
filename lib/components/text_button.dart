import 'package:flutter/material.dart';
import 'package:music_player/constant.dart';

class TextButton extends StatelessWidget {
  const TextButton({
    Key key,
    @required this.text,
    @required this.onPressed,
  }) : super(key: key);

  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Text(
        text,
        textAlign: TextAlign.left,
        style: kBottomSheetTextStyle,
      ),
      onTap: onPressed,
    );
  }
}
