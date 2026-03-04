import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/sensor_point.dart';

// without time and date stamp 

// final temperatureHistoryProvider =
//     StateProvider<List<double>>((ref) => []);

// with time and date stamp

final temperatureHistoryProvider =
    StateProvider<List<SensorPoint>>((ref) => []);