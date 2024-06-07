import 'package:audioplayers/audioplayers.dart';

class AudioPlayerService {
  static final AudioPlayerService _instance = AudioPlayerService._internal();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = true;

  factory AudioPlayerService() {
    return _instance;
  }

  AudioPlayerService._internal();

  Stream<bool> get isPlayingStream =>
      _audioPlayer.onPlayerStateChanged.map((state) => state == PlayerState.playing);

  Future<void> play() async {
    await _audioPlayer.setSource(AssetSource('audio.mp3'));
    await _audioPlayer.resume();
    _isPlaying = true;
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
  }

  bool get isPlaying => _isPlaying;
}
