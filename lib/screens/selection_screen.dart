import 'package:flutter/material.dart';
import 'package:music_player/constant.dart';
import 'package:music_player/components/circle_checkbox.dart';
import 'package:music_player/screens/favorite_screen.dart';
import 'package:music_player/store/audio.dart';
import 'package:provider/provider.dart';
import 'package:music_player/database.dart';
import 'package:music_player/models/music.dart';

class SelectionScreen extends StatefulWidget {
  static const routeName = 'SelectionScreen';

  @override
  _SelectionScreenState createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  bool _selectAll = false;
  int _count = 0;
  List<Music> _musics = [];

  @override
  void initState() {
    super.initState();
    print('initstate');
    setState(() {
      _musics = context.read<Audio>().musicList.map((music) {
        return Music(
          title: music.title,
          url: music.url,
          favorite: false,
        );
      }).toList();
    });
  }

  List<Music> _getFavList() {
    return _musics.where((music) => music.favorite).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('$_count item${_count > 1 ? 's' : ''} selected'),
        centerTitle: true,
        backgroundColor: kBackgroundColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.check,
            ),
            onPressed: () async {
              final favoriteList = _getFavList();

              final store = context.read<Audio>();

              final newMusicList = store.musicList.map((music) {
                var favorite = music.favorite;
                for (var element in favoriteList) {
                  if (element.url == music.url) {
                    favorite = true;
                    break;
                  }
                }
                return Music(
                  title: music.title,
                  url: music.url,
                  favorite: favorite,
                );
              }).toList();

              store.setMusicList(newMusicList);

              final dbFavList = await getData(table: 'favorites');
              for (var music in newMusicList) {
                bool found = false;
                if (music.favorite) {
                  for (var element in dbFavList) {
                    if (music.url == element.url) {
                      found = true;
                      break;
                    }
                  }
                  if (!found) {
                    insert(music: music, table: 'favorites');
                  }
                } else {
                  delete(url: music.url, table: 'favorites');
                }
              }
              Navigator.pushNamed(context, FavoriteScreen.routeName);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            CircleCheckbox(
              checked: _selectAll,
              margin: EdgeInsets.only(
                right: 12.0,
              ),
              checkColor: kPlayerIconColor,
              onChecked: (v) {
                setState(() {
                  _selectAll = v;
                  for (var music in _musics) {
                    music.favorite = v;
                  }
                  if (v) {
                    _count = _getFavList().length;
                  } else {
                    _count = 0;
                  }
                });
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _musics.length,
                itemBuilder: (context, i) {
                  return ListTile(
                    title: Text(
                      _musics[i].title,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                    subtitle: Text('Unknown Artist | Unknown Album'),
                    trailing: CircleCheckbox(
                      checkColor: kPlayerIconColor,
                      checked: _musics[i].favorite,
                      onChecked: (v) {
                        setState(() {
                          _musics[i].favorite = v;
                          if (v) {
                            _count++;
                          } else {
                            _count--;
                          }
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
