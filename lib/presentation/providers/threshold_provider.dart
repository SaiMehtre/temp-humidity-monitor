import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/threshold_settings.dart';

final thresholdProvider =
    StateNotifierProvider<ThresholdNotifier, ThresholdSettings>((ref) {
  return ThresholdNotifier();
});

class ThresholdNotifier extends StateNotifier<ThresholdSettings> {
  ThresholdNotifier()
      : super(
          ThresholdSettings(
            tempMin: 18,
            tempMax: 35,
            tempEnabled: true,
            humidityMin: 30,
            humidityMax: 70,
            humidityEnabled: true,
          ),
        );

  void updateTemp(double min, double max) {
    state = state.copyWith(tempMin: min, tempMax: max);
  }

  void toggleTemp(bool value) {
    state = state.copyWith(tempEnabled: value);
  }

  void updateHumidity(double min, double max) {
    state = state.copyWith(humidityMin: min, humidityMax: max);
  }

  void toggleHumidity(bool value) {
    state = state.copyWith(humidityEnabled: value);
  }
}