// import 'package:audioplayers/audioplayers.dart';

// class AlertService {
//   static final AudioPlayer _player = AudioPlayer();

//   static Future<void> triggerAlert() async {
//   try {
//     await _player.stop();
//     await _player.setReleaseMode(ReleaseMode.stop);
//     await _player.play(AssetSource('sounds/alert.wav'));
//   } catch (e) {
//     print("ALERT ERROR: $e");
//   }
// }
// }


import 'package:audioplayers/audioplayers.dart';

class AlertService {
  static final AudioPlayer _player = AudioPlayer();
  static bool _isPlaying = false;

  static Future<void> startAlert() async {
    if (_isPlaying) return;

    try {
      _isPlaying = true;
      await _player.setReleaseMode(ReleaseMode.loop); // 🔥 LOOP
      await _player.play(AssetSource('sounds/alert.wav'));
    } catch (e) {
      print("ALERT ERROR: $e");
    }
  }

  static Future<void> stopAlert() async {
    try {
      _isPlaying = false;
      await _player.stop();
    } catch (e) {
      print("STOP ERROR: $e");
    }
  }
}