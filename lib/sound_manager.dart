

import 'package:audioplayers/audioplayers.dart';

class SoundManager {
  AudioPlayer backgroundMusicPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  AudioPlayer actionSoundManager = AudioPlayer(mode: PlayerMode.LOW_LATENCY);


  void playBackgroundMusic() async {
    int result = await backgroundMusicPlayer.play('assets/sounds/backgroundSound.mp3', isLocal: true);
  }
  void stopBackgroundMusic() async {
    int result = await backgroundMusicPlayer.stop();
  }
  void playCorrectAnswerSound() async {
    int result = await actionSoundManager.play('assets/sounds/correctAnswerSound.mp3', isLocal: true);
  }
  void playWrongAnswerSound() async {
    int result = await actionSoundManager.play('assets/sounds/wrongAnswerSound.wav', isLocal: true);
  }
}