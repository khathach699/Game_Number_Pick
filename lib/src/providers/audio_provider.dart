import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioProvider extends ChangeNotifier {
  final AudioPlayer _backgroundMusicPlayer = AudioPlayer();
  final AudioPlayer _soundEffectPlayer = AudioPlayer();
  bool _isMusicEnabled = true;
  bool _isSoundEnabled = false;
  bool _isInGamePage = false;

  bool get isMusicEnabled => _isMusicEnabled;
  bool get isSoundEnabled => _isSoundEnabled;
  bool get isInGamePage => _isInGamePage;

  AudioProvider();

  // Gọi khi vào GamePage
  void enterGamePage() {
    _isInGamePage = true;
    if (_isMusicEnabled) {
      playBackgroundMusic();
    }
    notifyListeners();
  }

  // Gọi khi rời GamePage
  void exitGamePage() {
    _isInGamePage = false;
    stopBackgroundMusic();
    notifyListeners();
  }

  // Bật/tắt nhạc nền
  void toggleMusic(bool enable) {
    _isMusicEnabled = enable;
    if (_isInGamePage) {
      if (_isMusicEnabled) {
        playBackgroundMusic();
      } else {
        stopBackgroundMusic();
      }
    }
    notifyListeners();
  }

  // Bật/tắt âm thanh nút
  void toggleSound(bool enable) {
    _isSoundEnabled = enable;
    notifyListeners();
  }

  // Phát nhạc nền
  Future<void> playBackgroundMusic() async {
    if (_isMusicEnabled && _isInGamePage) {
      await _backgroundMusicPlayer.setSource(AssetSource("audios/background_music.mp3"));
      await _backgroundMusicPlayer.setReleaseMode(ReleaseMode.loop);
      await _backgroundMusicPlayer.setVolume(0.5);
      await _backgroundMusicPlayer.resume();
    }
  }


  Future<void> stopBackgroundMusic() async {
    await _backgroundMusicPlayer.stop();
  }


  Future<void> playButtonClickSound() async {
    if (_isSoundEnabled) {
      final player = AudioPlayer(); // Tạo instance mới
      await player.setSource(AssetSource("audios/button_click.mp3"));
      await player.setVolume(1.0);
      await player.resume();
      // Tự động giải phóng sau khi phát xong
      player.onPlayerComplete.listen((_) {
        player.dispose();
      });
    }
  }

  @override
  void dispose() {
    _backgroundMusicPlayer.dispose();
    _soundEffectPlayer.dispose();
    super.dispose();
  }
}