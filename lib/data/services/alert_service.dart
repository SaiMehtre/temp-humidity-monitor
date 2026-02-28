import 'package:audioplayers/audioplayers.dart';

class AlertService {
  static final AudioPlayer _player = AudioPlayer();

  static bool _isPlaying = false;
  static DateTime? _snoozeUntil;
  static DateTime? tempSnoozeUntil;
  static DateTime? humiditySnoozeUntil;

  static void snoozeTemp(int minutes) {
    tempSnoozeUntil =
        DateTime.now().add(Duration(minutes: minutes));
    stopAlert();
  }

  static void snoozeHumidity(int minutes) {
    humiditySnoozeUntil =
        DateTime.now().add(Duration(minutes: minutes));
    stopAlert();
  }

  static Future<void> startAlert() async {
    if (_isPlaying) return;

    if (_snoozeUntil != null &&
        DateTime.now().isBefore(_snoozeUntil!)) {
      return;
    }

    _isPlaying = true;

    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.play(AssetSource('sounds/alert.wav'));
  }

  static Future<void> stopAlert() async {
    _isPlaying = false;
    await _player.stop();
  }

  static void snooze(int minutes) {
    _snoozeUntil =
        DateTime.now().add(Duration(minutes: minutes));
    stopAlert();
  }
}