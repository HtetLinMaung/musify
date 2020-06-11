import 'package:flutter/material.dart';
import 'package:music_player/constant.dart';
import 'package:music_player/components/circle_checkbox.dart';
import 'package:music_player/store/audio.dart';
import 'package:provider/provider.dart';
import 'package:music_player/database.dart';

class SelectionScreen extends StatefulWidget {
  static const routeName = 'SelectionScreen';

  @override
  _SelectionScreenState createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  bool _selectAll = false;

  bool _checkSelectAll(Audio store) {
    final selectAll = store.musicList.every((music) => music.favorite);
    if (selectAll) {
      setState(() {
        _selectAll = true;
      });
    }
    return _selectAll;
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<Audio>();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
            '${store.musicList.where((music) => music.favorite).toList().length} items selected'),
        centerTitle: true,
        backgroundColor: kBackgroundColor,
        actions: <Widget>[
          CircleCheckbox(
            checked: _checkSelectAll(store),
            margin: EdgeInsets.only(
              right: 12.0,
            ),
            checkColor: kPlayerIconColor,
            onChecked: (v) {
              setState(() {
                _selectAll = v;
                if (v) {
                  store.setMusicList(store.musicList.map((music) {
                    if (!music.favorite) {
                      music.favorite = true;
                      insert(
                        music: music,
                        table: 'favorites',
                      );
                    }
                    return music;
                  }).toList());
                } else {
                  store.setMusicList(store.musicList.map((music) {
                    if (music.favorite) {
                      music.favorite = false;
                      delete(
                        url: music.url,
                        table: 'favorites',
                      );
                    }
                    return music;
                  }).toList());
                }
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.builder(
          itemCount: store.musicList.length,
          itemBuilder: (context, i) {
            return ListTile(
              title: Text(
                store.musicList[i].title,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
              ),
              subtitle: Text('Unknown Artist | Unknown Album'),
              trailing: CircleCheckbox(
                checkColor: kPlayerIconColor,
                checked: store.musicList[i].favorite,
                onChecked: (v) {
                  final store = context.read<Audio>();
                  store.musicList[i].favorite = v;
                  store.setMusicList(store.musicList);
                  final music = store.musicList[i];
                  if (music.favorite) {
                    insert(
                      music: music,
                      table: 'favorites',
                    );
                  } else {
                    delete(
                      url: music.url,
                      table: 'favorites',
                    );
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
