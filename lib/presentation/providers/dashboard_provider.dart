import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/sensor_data.dart';
import '../../data/mock/mock_sensor_data.dart';
import '../../presentation/providers/interval_provider.dart';

final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, SensorData>((ref) {
  return DashboardNotifier(ref);
});

class DashboardNotifier extends StateNotifier<SensorData> {
  final Ref ref;
  Timer? _timer;

  DashboardNotifier(this.ref) : super(MockSensorData.getData()) {
    _startAutoUpdate();

    // 🔥 IMPORTANT: interval change listener
    ref.listen<int>(intervalProvider, (_, __) {
      _startAutoUpdate(); // restart timer
    });
  }

  void _startAutoUpdate() {
    _timer?.cancel();

    final seconds = ref.read(intervalProvider);

    _timer = Timer.periodic(Duration(seconds: seconds), (_) {
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