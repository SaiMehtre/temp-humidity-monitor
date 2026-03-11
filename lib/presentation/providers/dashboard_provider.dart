import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/sensor_data.dart';
import '../../data/mock/mock_sensor_data.dart';
import '../../presentation/providers/interval_provider.dart';
import '../../presentation/providers/temp_history_provider.dart'; 
import '../../presentation/providers/humidity_history_provider.dart'; 
import '../../data/models/sensor_point.dart';

final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, SensorData>((ref) {
  return DashboardNotifier(ref);
});

class DashboardNotifier extends StateNotifier<SensorData> {
  final Ref ref;
  Timer? _timer;

  DashboardNotifier(this.ref) : super(MockSensorData.getData()) {
    _startAutoUpdate();

    // IMPORTANT: interval change listener
    ref.listen<int>(intervalProvider, (_, __) {
      _startAutoUpdate(); // restart timer
    });
  }

  void _startAutoUpdate() {
    _timer?.cancel();

    final seconds = ref.read(intervalProvider);

    _timer = Timer.periodic(Duration(seconds: seconds), (_) {
    final newData = MockSensorData.getData();
    state = newData;

    // // Temperature history
    // ref.read(temperatureHistoryProvider.notifier).update((prev) {
    //   final updated = [...prev, newData.temperature];
    //   if (updated.length > 20) updated.removeAt(0);
    //   return updated;
    // });

    // // Humidity history
    // ref.read(humidityHistoryProvider.notifier).update((prev) {
    //   final updated = [...prev, newData.humidity];
    //   if (updated.length > 20) updated.removeAt(0);
    //   return updated;
    // });

    final now = DateTime.now();

    // Temperature history
    ref.read(temperatureHistoryProvider.notifier).update((prev) {
      final updated = [...prev, SensorPoint(newData.temperature, now)];
      if (updated.length > 20) updated.removeAt(0);
      return updated;
    });

    // Humidity history
    ref.read(humidityHistoryProvider.notifier).update((prev) {
      final updated = [...prev, SensorPoint(newData.humidity, now)];
      if (updated.length > 20) updated.removeAt(0);
      return updated;
    });

    print("Temp: ${newData.temperature}");
    print("Humidity: ${newData.humidity}");
  });
  }

  void refreshData() {
    final newData = MockSensorData.getData();
    final now = DateTime.now();

    state = newData;

    // Temperature
    ref.read(temperatureHistoryProvider.notifier).update((prev) {
      final updated = [...prev, SensorPoint(newData.temperature, now)];
      if (updated.length > 50) updated.removeAt(0);
      return updated;
    });

    // Humidity
    ref.read(humidityHistoryProvider.notifier).update((prev) {
      final updated = [...prev, SensorPoint(newData.humidity, now)];
      if (updated.length > 50) updated.removeAt(0);
      return updated;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}