import 'package:hive/hive.dart';

part 'alert_history.g.dart';

@HiveType(typeId: 0)
class AlertHistory {

  @HiveField(0)
  final String type;

  @HiveField(1)
  final double value;

  @HiveField(2)
  final DateTime time;

  AlertHistory(this.type, this.value, this.time);
}