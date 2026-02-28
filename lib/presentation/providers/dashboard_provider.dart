import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/sensor_data.dart';
import '../../data/mock/mock_sensor_data.dart';

final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, SensorData>((ref) {
  return DashboardNotifier();
});

class DashboardNotifier extends StateNotifier<SensorData> {
  DashboardNotifier() : super(MockSensorData.getData()) {
    Future.microtask(() => refreshData());
  }

  void refreshData() {
    state = MockSensorData.getData();
  }
}
