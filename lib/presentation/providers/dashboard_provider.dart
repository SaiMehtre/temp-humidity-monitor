import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/sensor_data.dart';
import '../../data/mock/mock_sensor_data.dart';

final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, SensorData>((ref) {
  return DashboardNotifier();
});

class DashboardNotifier extends StateNotifier<SensorData> {
  Timer? _timer;

  DashboardNotifier() : super(MockSensorData.getData()) {
    _startAutoUpdate();
  }

  void _startAutoUpdate() {
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {    // Duration(seconds: 30), Duration(minutes: 1), Duration(minutes: 5).
      state = MockSensorData.getData();
    });
  }

  void refreshData() {
    state = MockSensorData.getData();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}