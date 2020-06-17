import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:music_player/database.dart';
import 'package:music_player/models/music.dart';
import 'package:music_player/constant.dart';
import 'package:music_player/models/playlist.dart';

class Audio with ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<Music> _musicList = [];
  String _currentUrl = '';
  PlayerState _playerState = PlayerState.STOPPED;
  TrackState _trackState = TrackState.LOOP;
  Play _play = Play.NONE;
  Duration _duration = Duration(seconds: 0);
  Duration _position = Duration(seconds: 0);
  bool _muted = false;
  Playlist _playlist;

  Audio() {
    _audioPlayer.onPlayerStateChanged.listen((s) {
      if (s == AudioPlayerState.PLAYING) {
        _playerState = PlayerState.PLAYING;
        _duration = audioPlayer.duration;
      } else if (s == AudioPlayerState.PAUSED) {
        _playerState = PlayerState.PAUSED;
      } else if (s == AudioPlayerState.COMPLETED) {
        _position = _duration;
        _playerState = PlayerState.COMPLETED;
        if (_trackState == TrackState.REPEAT) {
          stopAndPlay(_currentUrl);
        } else {
          next();
        }
      }

      notifyListeners();
    });
    _audioPlayer.onAudioPositionChanged.listen((p) {
      _position = p;
      notifyListeners();
    });
  }

  AudioPlayer get audioPlayer => _audioPlayer;
  List<Music> get musicList => _musicList;
  PlayerState get playerState => _playerState;
  TrackState get trackState => _trackState;
  Duration get duration => _duration;
  Duration get position => _position;
  bool get muted => _muted;
  String get currentUrl => _currentUrl;
  Playlist get playlist => _playlist;

  void setPlaylist(Playlist playlist) {
    _playlist = playlist;
  }

  void setPlay(Play p) {
    _play = p;
  }

  void mute() {
    _muted = !_muted;
    notifyListeners();
    _audioPlayer.mute(_muted);
  }

  void setTrackState(TrackState s) {
    _trackState = s;
    notifyListeners();
  }

  void seek(double seconds) async {
    if (_playerState == PlayerState.PAUSED) {
      await resume();
    }
    _audioPlayer.seek(seconds);
  }

  void setMusicList(List<Music> list) {
    _musicList = list;
    notifyListeners();
  }

  void stopAndPlay(String url) {
    _position = Duration(seconds: 0);
    _currentUrl = url;
    notifyListeners();
    _audioPlayer.stop();
    _audioPlayer.play(_currentUrl, isLocal: true);
  }

  void pause() {
    _audioPlayer.pause();
  }

  Future<void> resume() {
    return _audioPlayer.play(_currentUrl);
  }

  List<Music> getFavorites() {
    return _musicList.where((music) => music.favorite).toList();
  }

  void next() {
    _skip();
  }

  void shufflePlay({Play play = Play.NONE}) {
    _trackState = TrackState.SHUFFLE;
    _play = play;

    var musicList = _musicList;
    if (_play == Play.FAVORITE) {
      musicList = musicList.where((music) => music.favorite).toList();
    }
    final index = Random().nextInt(musicList.length);
    stopAndPlay(musicList[index].url);
  }

  void previous() {
    _skip(previous: true);
  }

  void _skip({bool previous = false}) async {
    var musicList = _musicList;
    var index = musicList.indexOf(getCurrentMusic());
    if (_play == Play.FAVORITE) {
      musicList = getFavorites();
      index = musicList
          .indexOf(musicList.firstWhere((music) => music.url == _currentUrl));
    } else if (_play == Play.PLAYLIST) {
      musicList = await getPlaylistMusics();
      index = musicList
          .indexOf(musicList.firstWhere((music) => music.url == _currentUrl));
    }
    if (_trackState == TrackState.LOOP || _trackState == TrackState.REPEAT) {
      if (previous) {
        if (index == 0) {
          index = musicList.length - 1;
        } else {
          index--;
        }
      } else {
        if (index == musicList.length - 1) {
          index = 0;
        } else {
          index++;
        }
      }
    } else if (_trackState == TrackState.SHUFFLE) {
      index = Random().nextInt(musicList.length);
    }
    stopAndPlay(musicList[index].url);
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
