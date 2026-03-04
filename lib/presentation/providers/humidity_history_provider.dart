import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/sensor_point.dart';

// without time and date stamp 

// final humidityHistoryProvider =
//     StateProvider<List<double>>((ref) => []);


final humidityHistoryProvider =
    StateProvider<List<SensorPoint>>((ref) => []);