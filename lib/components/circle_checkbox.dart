import 'package:flutter/material.dart';

class CircleCheckbox extends StatelessWidget {
  const CircleCheckbox({
    Key key,
    @required this.checked,
    @required this.onChecked,
    this.checkColor = Colors.green,
    this.margin,
  }) : super(key: key);

  final bool checked;
  final void Function(bool v) onChecked;
  static const double iconSize = 10.0;
  final Color checkColor;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: margin,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: checked ? checkColor : Colors.transparent,
            border: Border.all(
              color: checkColor,
            )),
        child: Icon(
          Icons.check,
          size: iconSize,
          color: checked ? Colors.white : Colors.transparent,
        ),
      ),
      onTap: () => onChecked(!checked),
    );
  }
}
