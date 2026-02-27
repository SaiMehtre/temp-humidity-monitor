// import 'package:audioplayers/audioplayers.dart';

// class AlertService {
//   static final AudioPlayer _player = AudioPlayer();

//   static Future<void> triggerAlert() async {
//     await _player.play(AssetSource('alert.mp3'));
//   }
// }

import 'package:audioplayers/audioplayers.dart';

class AlertService {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> triggerAlert() async {
    await _player.setReleaseMode(ReleaseMode.stop);
    await _player.play(
      AssetSource('sounds/alert.wav'),
    );
  }
}