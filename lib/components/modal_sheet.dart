import 'package:flutter/material.dart';
import 'package:music_player/constant.dart';

class ModalSheet extends StatelessWidget {
  const ModalSheet({Key key, @required this.child, this.height})
      : super(key: key);

  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff0B0217),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(35.0),
            topRight: Radius.circular(35.0),
          ),
          color: kBottomSheetColor,
        ),
        padding: EdgeInsets.symmetric(
          vertical: 30.0,
          horizontal: 30.0,
        ),
        height: height,
        child: child,
      ),
    );
  }
}
