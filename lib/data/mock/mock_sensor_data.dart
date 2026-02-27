import '../models/sensor_data.dart';

class MockSensorData {
  static SensorData getData() {
    return SensorData(
      temperature: 28.5,
      humidity: 62.3,
      isOnline: true,
      lastUpdated: DateTime.now(),
    );
  }
}