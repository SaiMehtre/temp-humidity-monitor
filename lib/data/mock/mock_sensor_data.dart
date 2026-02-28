import '../models/sensor_data.dart';

class MockSensorData {
  static double _temperature = 25;
  static double _humidity = 30;

  static bool _increasing = true;

  static SensorData getData() {
    if (_increasing) {
      _temperature += 5;
      _humidity += 5;

      if (_temperature >= 50 && _humidity >= 75) {
        _increasing = false;
      }
    } else {
      _temperature -= 5;
      _humidity -= 5;

      if (_temperature <= 25) {
        _increasing = true;
      }
    }

    return SensorData(
      temperature: _temperature,
      humidity: _humidity,
      isOnline: true,
      lastUpdated: DateTime.now(),
    );
  }
}