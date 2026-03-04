import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../providers/temp_history_provider.dart';
import '../providers/humidity_history_provider.dart';

class CombinedChart extends ConsumerWidget {
  const CombinedChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tempHistory = ref.watch(temperatureHistoryProvider);
    final humidityHistory = ref.watch(humidityHistoryProvider);

    if (tempHistory.isEmpty) {
      return const SizedBox(
        height: 300,
        child: Center(child: Text("No Data")),
      );
    }

    return SizedBox(
      height: 300,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (tempHistory.length - 1).toDouble(),

          // ✅ TIME LABELS
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 2,
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  if (index >= tempHistory.length) {
                    return const SizedBox();
                  }

                  final time = tempHistory[index].time;
                  final formatted =
                      DateFormat.Hms().format(time); // HH:mm:ss

                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      formatted,
                      style: const TextStyle(fontSize: 9),
                    ),
                  );
                },
              ),
            ),
          ),

          borderData: FlBorderData(show: true),

          lineBarsData: [
            // 🔥 Temperature Line
            LineChartBarData(
              spots: List.generate(
                tempHistory.length,
                (i) => FlSpot(
                  i.toDouble(),
                  tempHistory[i].value,
                ),
              ),
              isCurved: true,
              dotData: FlDotData(show: false),
            ),

            // 🔥 Humidity Line
            LineChartBarData(
              spots: List.generate(
                humidityHistory.length,
                (i) => FlSpot(
                  i.toDouble(),
                  humidityHistory[i].value,
                ),
              ),
              isCurved: true,
              dotData: FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}