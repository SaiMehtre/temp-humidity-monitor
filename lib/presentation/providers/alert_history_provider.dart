import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/alert_history.dart';

final alertHistoryProvider =
    StateProvider<List<AlertHistory>>((ref) => []);