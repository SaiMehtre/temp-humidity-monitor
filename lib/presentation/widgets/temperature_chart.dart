import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/temp_history_provider.dart';

class TemperatureChart extends ConsumerWidget {
  const TemperatureChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(temperatureHistoryProvider);

    if (data.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text("No data yet")),
      );
    }

              print("Chart Data Length: ${data.length}");
    return SizedBox(
      height: 250,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                data.length,
                (index) => FlSpot(index.toDouble(), data[index]),
              ),
              isCurved: true,
              dotData: FlDotData(show: false),
              barWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}