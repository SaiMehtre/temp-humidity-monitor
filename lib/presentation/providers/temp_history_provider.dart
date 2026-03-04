import 'package:flutter_riverpod/flutter_riverpod.dart';

final temperatureHistoryProvider =
    StateProvider<List<double>>((ref) => []);