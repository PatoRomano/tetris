import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class MusicPlayerController extends ChangeNotifier {
  late final AudioPlayer _audioPlayer = AudioPlayer();

  void playMusic() {
    _audioPlayer.setAsset('assets/sounds/menuMusic.mp3');
    _audioPlayer.setLoopMode(LoopMode.one);
    _audioPlayer.setVolume(0.3);
    _audioPlayer.play();
  }

  void stopMusic() {
    _audioPlayer.stop();
  }
}