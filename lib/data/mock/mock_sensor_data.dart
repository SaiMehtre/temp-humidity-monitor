import '../models/sensor_data.dart';

class MockSensorData {
  static SensorData getData() {
    return SensorData(
      temperature: 25,
      humidity: 76,
      isOnline: true,
      lastUpdated: DateTime.now(),
    );
  }
}