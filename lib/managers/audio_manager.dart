import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  final AudioPlayer _musicPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();
  bool _musicPlaying = false;

  Future<void> init() async {
    // placeholder: ensure audio session initialized if needed
    return;
  }

  Future<void> playMusic() async {
    // Attempt to play a looping background audio if asset available
    try {
      _musicPlaying = true;
      // Example: await _musicPlayer.setSource(AssetSource('audio/bgm.mp3'));
      // await _musicPlayer.setReleaseMode(ReleaseMode.loop);
      // await _musicPlayer.resume();
    } catch (_) {}
  }

  Future<void> stopMusic() async {
    _musicPlaying = false;
    try {
      await _musicPlayer.stop();
    } catch (_) {}
  }

  void playCatch() {
    // stub for catch SFX
    // _sfxPlayer.play(AssetSource('audio/catch.wav'));
  }

  void playFail() {
    // _sfxPlayer.play(AssetSource('audio/fail.wav'));
  }

  void playLevelUp() {
    // _sfxPlayer.play(AssetSource('audio/levelup.wav'));
  }

  void playColorChange() {
    // _sfxPlayer.play(AssetSource('audio/color_change.wav'));
  }
}
import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  final AudioPlayer _sfxPlayer = AudioPlayer();
  final AudioPlayer _musicPlayer = AudioPlayer();

  Future<void> init() async {
    await _sfxPlayer.setReleaseMode(ReleaseMode.stop);
    await _musicPlayer.setReleaseMode(ReleaseMode.loop);
  }

  void playCatch() {
    _playSfx('assets/audio/catch.wav');
  }

  void playFail() {
    _playSfx('assets/audio/fail.wav');
  }

  void playLevelUp() {
    _playSfx('assets/audio/levelup.wav');
  }

  void playColorChange() {
    _playSfx('assets/audio/change_color.wav');
  }

  Future<void> _playSfx(String assetPath) async {
    final player = AudioPlayer();
    await player.play(AssetSource(assetPath));
    player.onPlayerComplete.listen((event) {
      player.dispose();
    });
  }

  void playMusic() async {
    // Placeholder for background music if you add a bgm.wav asset
    // await _musicPlayer.play(AssetSource('assets/audio/bgm.wav'));
  }

  void stopMusic() {
    _musicPlayer.stop();
  }
}
