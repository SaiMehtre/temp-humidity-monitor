class ThresholdSettings {
  final double tempMin;
  final double tempMax;
  final bool tempEnabled;

  final double humidityMin;
  final double humidityMax;
  final bool humidityEnabled;

  ThresholdSettings({
    required this.tempMin,
    required this.tempMax,
    required this.tempEnabled,
    required this.humidityMin,
    required this.humidityMax,
    required this.humidityEnabled,
  });

  ThresholdSettings copyWith({
    double? tempMin,
    double? tempMax,
    bool? tempEnabled,
    double? humidityMin,
    double? humidityMax,
    bool? humidityEnabled,
  }) {
    return ThresholdSettings(
      tempMin: tempMin ?? this.tempMin,
      tempMax: tempMax ?? this.tempMax,
      tempEnabled: tempEnabled ?? this.tempEnabled,
      humidityMin: humidityMin ?? this.humidityMin,
      humidityMax: humidityMax ?? this.humidityMax,
      humidityEnabled: humidityEnabled ?? this.humidityEnabled,
    );
  }
}