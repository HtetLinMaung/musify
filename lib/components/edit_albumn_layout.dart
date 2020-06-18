import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_player/constant.dart';

class EditAlbumLayout extends StatelessWidget {
  final Function backPressed;
  final Function onAccepted;
  final String appBarTitle;
  final String hintText;
  final String hintText2;
  final String hintText3;
  final File image;
  final TextEditingController controller;
  final TextEditingController controller2;
  final TextEditingController controller3;
  final Function onTapImage;

  EditAlbumLayout({
    @required this.backPressed,
    @required this.appBarTitle,
    @required this.onAccepted,
    @required this.hintText,
    @required this.hintText2,
    @required this.hintText3,
    @required this.controller,
    @required this.controller2,
    @required this.controller3,
    @required this.image,
    @required this.onTapImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: backPressed,
        ),
        elevation: 0,
        backgroundColor: kBackgroundColor,
        title: Text(appBarTitle),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.check,
            ),
            onPressed: onAccepted,
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Card(
            margin: EdgeInsets.symmetric(
              horizontal: 50,
              vertical: 30,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            color: kInActiveColor,
            child: InkWell(
              splashColor: Colors.purple.withAlpha(30),
              onTap: onTapImage,
              child: Container(
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35),
                  image: DecorationImage(
                    image: FileImage(image),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Center(
                  child: FaIcon(
                    FontAwesomeIcons.music,
                    color:
                        image.existsSync() ? Colors.transparent : Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 29.0,
              vertical: 10.0,
            ),
            child: Text(
              'Edit Texts',
              style: TextStyle(
                fontSize: 20,
                color: kPlayerIconColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 15,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text('Name: '),
                ),
                Expanded(
                  flex: 3,
                  child: TextField(
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(
                          style: BorderStyle.none,
                          width: 0,
                        ),
                      ),
                      hintText: hintText,
                    ),
                    controller: controller,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 15,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text('Album: '),
                ),
                Expanded(
                  flex: 3,
                  child: TextField(
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(
                          style: BorderStyle.none,
                          width: 0,
                        ),
                      ),
                      hintText: hintText2,
                    ),
                    controller: controller2,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 15,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text('Artist: '),
                ),
                Expanded(
                  flex: 3,
                  child: TextField(
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(
                          style: BorderStyle.none,
                          width: 0,
                        ),
                      ),
                      hintText: hintText3,
                    ),
                    controller: controller3,
                  ),
                ),
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
