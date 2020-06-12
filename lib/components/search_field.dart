import 'package:flutter/material.dart';
import 'package:music_player/constant.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    Key key,
    @required this.onChanged,
  }) : super(key: key);

  final Function(String v) onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: kInputColor,
          ),
          hintText: 'Song or Artist',
          fillColor: kInputFillColor,
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(
                style: BorderStyle.none,
                width: 0,
              )),
          hintStyle: TextStyle(
            color: kInputColor,
          ),
        ),
      ),
    );
  }
}
