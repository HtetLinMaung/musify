import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:music_player/models/music.dart';
import 'package:music_player/constant.dart';

class Audio with ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<Music> _musicList = [];
  String _currentUrl = '';
  PlayerState _playerState;
  TrackState _trackState = TrackState.LOOP;
  Duration _duration = Duration(seconds: 0);
  Duration _position = Duration(seconds: 0);
  bool _muted = false;

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
        next();
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

  void next() {
    _position = Duration(seconds: 0);
    var index = _musicList.indexOf(getCurrentMusic());
    if (_trackState == TrackState.LOOP) {
      if (index == _musicList.length - 1) {
        index = 0;
      } else {
        index++;
      }
    } else if (_trackState == TrackState.SHUFFLE) {
      index = Random().nextInt(_musicList.length);
    }
    stopAndPlay(_musicList[index].url);
  }

  void previous() {
    _position = Duration(seconds: 0);
    var index = _musicList.indexOf(getCurrentMusic());
    if (_trackState == TrackState.LOOP) {
      if (index == 0) {
        index = _musicList.length - 1;
      } else {
        index--;
      }
    } else if (_trackState == TrackState.SHUFFLE) {
      index = Random().nextInt(_musicList.length);
    }
    stopAndPlay(_musicList[index].url);
  }

  Music getCurrentMusic() {
    return _musicList.firstWhere((music) => music.url == _currentUrl);
  }
}
