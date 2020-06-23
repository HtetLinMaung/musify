import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/constant.dart';
import 'package:music_player/database.dart';

MediaControl playControl = MediaControl(
  androidIcon: 'drawable/ic_action_play_arrow',
  label: 'Play',
  action: MediaAction.play,
);
MediaControl pauseControl = MediaControl(
  androidIcon: 'drawable/ic_action_pause',
  label: 'Pause',
  action: MediaAction.pause,
);
MediaControl skipToNextControl = MediaControl(
  androidIcon: 'drawable/ic_action_skip_next',
  label: 'Next',
  action: MediaAction.skipToNext,
);
MediaControl skipToPreviousControl = MediaControl(
  androidIcon: 'drawable/ic_action_skip_previous',
  label: 'Previous',
  action: MediaAction.skipToPrevious,
);
MediaControl stopControl = MediaControl(
  androidIcon: 'drawable/ic_action_stop',
  label: 'Stop',
  action: MediaAction.stop,
);

class MyAudioTask extends BackgroundAudioTask {
  final AudioPlayer _player = AudioPlayer();
  List<dynamic> _musicList = [];
  TrackState _trackState = TrackState.LOOP;
  Play _play = Play.NONE;
  bool _playing = false;
  Duration _position = Duration();
  Duration _duration = Duration();
  String _currentUrl = '';
  Map<String, dynamic> _playlist = {};

  // Initialise your audio task
  @override
  Future<void> onStart(Map<String, dynamic> params) async {
    _musicList = params['musicList'];

    AudioServiceBackground.setState(
      controls: [pauseControl, stopControl],
      playing: _playing,
      processingState: AudioProcessingState.connecting,
    );

    _player.playbackStateStream.listen((event) {
      if (event == AudioPlaybackState.completed) {
        AudioServiceBackground.sendCustomEvent('completed');
        if (_trackState == TrackState.REPEAT) {
          playByUrl(_currentUrl);
        } else {
          _skip();
        }
      }
    });
    _player.getPositionStream().listen((position) {
      _position = position;
      AudioServiceBackground.setState(
        position: position,
        controls: getControls(),
        playing: _playing,
        processingState: AudioProcessingState.ready,
      );
      var urlList = _currentUrl.split('/');
      AudioServiceBackground.setMediaItem(MediaItem(
        id: _currentUrl ?? 'none',
        title: urlList[urlList.length - 1],
        duration: _duration,
        album: 'Unknown album',
      ));
    });
  }

  Future<void> playByUrl(url) async {
    _currentUrl = url;
    var urlList = url.split('/');
    _duration = await _player.setUrl(url);
    AudioServiceBackground.setMediaItem(MediaItem(
      id: _currentUrl ?? 'none',
      title: urlList[urlList.length - 1],
      duration: _duration,
      album: 'Unknown album',
    ));
    _playing = true;
    AudioServiceBackground.setState(
      controls: [pauseControl, stopControl],
      playing: _playing,
      processingState: AudioProcessingState.ready,
    );
    _player.play();
  }

  Future<List<dynamic>> getPlaylistMusics() async {
    final playlistMusics = await getMusicByPlaylist(_playlist['id']);
    return _musicList.where((music) {
      for (var item in playlistMusics) {
        if (music['url'] == item.url) {
          return true;
        }
      }
      return false;
    }).toList();
  }

  void _skip({bool previous = false}) async {
    var musicList = _musicList;
    var index = musicList.indexOf(
        musicList.firstWhere((element) => element['url'] == _currentUrl));
    if (_play == Play.FAVORITE) {
      musicList =
          musicList.where((element) => element['favorite'] == 1).toList();
      index = musicList.indexOf(
          musicList.firstWhere((music) => music['url'] == _currentUrl));
    } else if (_play == Play.PLAYLIST) {
      musicList = await getPlaylistMusics();
      index = musicList.indexOf(
          musicList.firstWhere((music) => music['url'] == _currentUrl));
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
    AudioServiceBackground.sendCustomEvent(
        'changeTrack:${musicList[index]['url']}');

    playByUrl(musicList[index]['url']);
  }

  List<MediaControl> getControls() {
    if (_playing) {
      return [
        skipToPreviousControl,
        pauseControl,
        stopControl,
        skipToNextControl
      ];
    } else {
      return [
        skipToPreviousControl,
        playControl,
        stopControl,
        skipToNextControl
      ];
    }
  }

  // Handle a request to stop audio and finish the task
  @override
  Future<void> onStop() async {
    // Stop playing audio
    _playing = false;
    await _player.stop();

    // Shut down this background task
    await super.onStop();
  }

  void onAudioFocusLost(AudioInterruption interruption) {
    print('onAudioFocusLost');
    print(interruption);
    switch (interruption) {
      case AudioInterruption.pause:
        _playing = false;
        _player.pause();
        break;
      default:
    }
  }

  @override
  void onPlay() {
    // Broadcast that we're playing, and what controls are available.
    AudioServiceBackground.setState(
      controls: [pauseControl, stopControl],
      playing: true,
      processingState: AudioProcessingState.ready,
      position: _position,
    );
    // Start playing audio.
    _playing = true;
    _player.play();
  }

  onSeekTo(Duration position) {
    _player.seek(position);
  }

  @override
  void onPause() {
    // Broadcast that we're paused, and what controls are available.
    AudioServiceBackground.setState(
      controls: [playControl, stopControl],
      playing: false,
      processingState: AudioProcessingState.ready,
      position: _position,
    );
    // Pause the audio.
    _playing = false;
    _player.pause();
  }

  void onAudioFocusGained(AudioInterruption interruption) {
    print('onAudioFocusGained');
    print(interruption);
  }

  Future<dynamic> onCustomAction(String name, [dynamic arguments]) async {
    switch (name) {
      case 'playNewMusic':
        await playByUrl(arguments);
        break;
      case 'mute':
        if (arguments) {
          _player.setVolume(0.0);
        } else {
          _player.setVolume(1.0);
        }
        break;
      case 'setMusicList':
        _musicList = arguments;
        break;
      case 'setTrackState':
        switch (arguments) {
          case 'loop':
            _trackState = TrackState.LOOP;
            break;
          case 'shuffle':
            _trackState = TrackState.SHUFFLE;
            break;
          default:
            _trackState = TrackState.REPEAT;
        }
        break;
      case 'setPlay':
        switch (arguments) {
          case 'favorite':
            _play = Play.FAVORITE;
            break;
          case 'playlist':
            _play = Play.PLAYLIST;
            break;
          default:
            _play = Play.NONE;
        }
        break;
      case 'setPlaylist':
        _playlist = arguments;
        break;
      case 'setCurrentUrl':
        _currentUrl = arguments;
        break;
      case 'next':
        _skip();
        break;
      case 'previous':
        _skip(previous: false);
        break;
      default:
    }

    return true;
  }
}
