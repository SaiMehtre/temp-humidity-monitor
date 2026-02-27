class SensorData {
  final double temperature;
  final double humidity;
  final bool isOnline;
  final DateTime lastUpdated;

  SensorData({
    required this.temperature,
    required this.humidity,
    required this.isOnline,
    required this.lastUpdated,
  });
}