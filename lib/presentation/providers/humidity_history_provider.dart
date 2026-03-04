import 'package:flutter_riverpod/flutter_riverpod.dart';

final humidityHistoryProvider =
    StateProvider<List<double>>((ref) => []);