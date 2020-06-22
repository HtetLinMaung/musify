import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

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
  bool _playing = false;
  Duration _position = Duration();
  Duration _duration = Duration();

  // Initialise your audio task
  @override
  Future<void> onStart(Map<String, dynamic> params) async {
    AudioServiceBackground.setState(
      controls: [pauseControl, stopControl],
      playing: _playing,
      processingState: AudioProcessingState.connecting,
    );
    String url = params['url'];

    playByUrl(url);
    _player.playbackStateStream.listen((event) {
      if (event == AudioPlaybackState.completed) {
        AudioServiceBackground.sendCustomEvent('completed');
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
    });
  }

  Future<void> playByUrl(url) async {
    var urlList = url.split('/');
    _duration = await _player.setUrl(url);
    AudioServiceBackground.setMediaItem(MediaItem(
      id: 'none',
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
        await _player.stop();
        await playByUrl(arguments);
        break;
      case 'mute':
        if (arguments) {
          _player.setVolume(0.0);
        } else {
          _player.setVolume(1.0);
        }
        break;
      default:
    }

    return true;
  }
}
