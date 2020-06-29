import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:music_player/audio_task.dart';
import 'package:music_player/database.dart';
import 'package:music_player/models/music.dart';
import 'package:music_player/constant.dart';
import 'package:music_player/models/playlist.dart';

_backgroundTaskEntrypoint() {
  AudioServiceBackground.run(() => MyAudioTask());
}

class Audio with ChangeNotifier {
  List<Music> _musicList = [];
  String _currentUrl = '';
  PlayerState _playerState = PlayerState.STOPPED;
  TrackState _trackState = TrackState.LOOP;
  Play _play = Play.NONE;
  Duration _duration = Duration(seconds: 0);
  Duration _position = Duration(seconds: 0);
  bool _muted = false;
  Playlist _playlist;
  String _currentImageUrl = '';

  Audio() {
    AudioService.playbackStateStream.listen((state) {
      if (state != null) {
        _position = state.position;
        if (state.playing) {
          _playerState = PlayerState.PLAYING;
        } else {
          _playerState = PlayerState.PAUSED;
        }
        notifyListeners();
      }
    });
    AudioService.currentMediaItemStream.listen((item) {
      if (item != null && item.duration != null) {
        _duration = item.duration;
        setUrls(item.id);
        notifyListeners();
      }
    });
    AudioService.customEventStream.listen((event) {
      if (event == 'completed') {
        _playerState = PlayerState.COMPLETED;
      } else if (event.startsWith('changeTrack')) {
        setUrls(event.split(':')[1]);
      } else if (event == 'stopApp') {
        SystemNavigator.pop();
      }
    });
  }

  List<Music> get musicList => _musicList;
  PlayerState get playerState => _playerState;
  TrackState get trackState => _trackState;
  Duration get duration => _duration;
  Duration get position => _position;
  bool get muted => _muted;
  String get currentUrl => _currentUrl;
  Playlist get playlist => _playlist;
  String get currentImageUrl => _currentImageUrl;

  void setDuration(Duration d) {
    _duration = d;
  }

  void setCurrentImageUrl(String url) {
    _currentImageUrl = url;
    AudioService.customAction('setCurrentImageUrl', url);
  }

  void setCurrentUrl(String url) {
    AudioService.customAction('setCurrentUrl', url);
    _currentUrl = url;
  }

  void setPlaylist(Playlist playlist) {
    AudioService.customAction('setPlaylist', playlist.toMap());
    _playlist = playlist;
  }

  void setPlay(Play p) {
    _play = p;
    switch (p) {
      case Play.FAVORITE:
        AudioService.customAction('setPlay', 'favorite');
        break;
      case Play.PLAYLIST:
        AudioService.customAction('setPlay', 'playlist');
        break;
      default:
        AudioService.customAction('setPlay', 'none');
    }
  }

  void mute() {
    _muted = !_muted;
    notifyListeners();
    AudioService.customAction('mute', _muted);
  }

  void setTrackState(TrackState s) {
    _trackState = s;
    notifyListeners();
  }

  void seek(double seconds) async {
    AudioService.seekTo(Duration(seconds: seconds.floor()));
  }

  void setMusicList(List<Music> list) {
    _musicList = list;
    if (AudioService.running) {
      AudioService.customAction(
          'setMusicList',
          List.generate(_musicList.length, (i) {
            return _musicList[i].toMap();
          }));
    }

    notifyListeners();
  }

  Future<void> initAudioService() async {
    await AudioService.start(
      backgroundTaskEntrypoint: _backgroundTaskEntrypoint,
      androidNotificationIcon: 'mipmap/ic_launcher',
      params: {
        'musicList': List.generate(_musicList.length, (i) {
          return _musicList[i].toMap();
        })
      },
    );
  }

  Future<void> setUrls(String url) async {
    _currentUrl = url;
    var musicImages = await getImageByMusic(_currentUrl);
    if (musicImages.isNotEmpty) {
      _currentImageUrl = musicImages[0].imageUrl;
    } else {
      _currentImageUrl = '';
    }
    notifyListeners();
  }

  void stopAndPlay(String url) async {
    _position = Duration(seconds: 0);
    await setUrls(url);
    await initAudioService();

    if (AudioService.running) {
      AudioService.customAction('playNewMusic', _currentUrl);
    }
  }

  void pause() {
    AudioService.pause();
  }

  Future<void> resume() {
    return AudioService.play();
  }

  List<Music> getFavorites() {
    return _musicList.where((music) => music.favorite).toList();
  }

  void next() {
    AudioService.customAction('next');
  }

  void shufflePlay({Play play = Play.NONE}) {
    _trackState = TrackState.SHUFFLE;
    AudioService.customAction('setTrackState', 'shuffle');
    setPlay(play);

    var musicList = _musicList;
    if (_play == Play.FAVORITE) {
      musicList = musicList.where((music) => music.favorite).toList();
    }
    final index = Random().nextInt(musicList.length);
    stopAndPlay(musicList[index].url);
  }

  void previous() {
    AudioService.customAction('previous');
  }

  Future<List<Music>> getPlaylistMusics() async {
    final playlistMusics = await getMusicByPlaylist(_playlist.id);
    return _musicList.where((music) {
      for (var item in playlistMusics) {
        if (music.url == item.url) {
          return true;
        }
      }
      return false;
    }).toList();
  }

  Music getCurrentMusic() {
    return _musicList.firstWhere((music) => music.url == _currentUrl);
  }
}
