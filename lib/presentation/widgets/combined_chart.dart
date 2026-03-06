import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../providers/temp_history_provider.dart';
import '../providers/humidity_history_provider.dart';

class CombinedBarChart extends ConsumerWidget {
  const CombinedBarChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tempHistory = ref.watch(temperatureHistoryProvider);
    final humidityHistory = ref.watch(humidityHistoryProvider);

    if (tempHistory.isEmpty && humidityHistory.isEmpty) {
      return const SizedBox(
        height: 300,
        child: Center(child: Text("No Data")),
      );
    }

    final maxX = [
      tempHistory.length,
      humidityHistory.length
    ].reduce((a, b) => a > b ? a : b);

    final tempMax = tempHistory.isNotEmpty
        ? tempHistory.map((e) => e.value).reduce((a, b) => a > b ? a : b)
        : 50.0;

    final humidityMax = humidityHistory.isNotEmpty
        ? humidityHistory.map((e) => e.value).reduce((a, b) => a > b ? a : b)
        : 100.0;

    final yMax = (tempMax > humidityMax ? tempMax : humidityMax) * 1.2;

    // Dynamic interval for X-axis labels
    int interval = 1;
    if (maxX > 20) interval = (maxX / 10).ceil();
    if (maxX > 50) interval = (maxX / 15).ceil();

    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          maxY: yMax,
          gridData: FlGridData(show: true),
          borderData: FlBorderData(border: Border.all(color: Colors.grey)),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, interval: yMax / 5),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: interval.toDouble(),
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  if (index < 0 || index >= tempHistory.length) return const SizedBox();
                  final time = tempHistory[index].time;
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      DateFormat('HH:mm').format(time),
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                },
              ),
            ),
          ),
          barGroups: List.generate(maxX, (i) {
            final temp = i < tempHistory.length ? tempHistory[i].value : 0.0;
            final humidity = i < humidityHistory.length ? humidityHistory[i].value : 0.0;
            return BarChartGroupData(
              x: i,
              barsSpace: 4,
              barRods: [
                BarChartRodData(
                  toY: temp,
                  width: 8,
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(2),
                ),
                BarChartRodData(
                  toY: humidity,
                  width: 8,
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(2),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}