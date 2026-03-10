import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../providers/temp_history_provider.dart';
import '../providers/humidity_history_provider.dart';

class ScrollableBarChart extends ConsumerWidget {
  const ScrollableBarChart({super.key});

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

    // final tempMax = tempHistory.isNotEmpty
    //     ? tempHistory.map((e) => e.value).reduce((a, b) => a > b ? a : b)
    //     : 50.0;

    // final humidityMax = humidityHistory.isNotEmpty
    //     ? humidityHistory.map((e) => e.value).reduce((a, b) => a > b ? a : b)
    //     : 100.0;

    // final yMax = (tempMax > humidityMax ? tempMax : humidityMax) * 1.2;

    // Bottom labels: max 6 on mobile for readability
    int totalPoints = maxX;
    int bottomInterval = 1;
    if (totalPoints > 6) bottomInterval = (totalPoints / 5).ceil();

    // Width of each group (bar + spacing)
    const double groupWidth = 40;

    return AspectRatio(
      // height: 320,
      aspectRatio: 1.2,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: maxX * groupWidth.toDouble() + 16,
          child: Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 20),
          child: BarChart(
            BarChartData(
              maxY: 100,
              minY: 0,
              gridData: FlGridData(show: true),
              borderData: FlBorderData(border: Border.all(color: Colors.grey)),
              titlesData: FlTitlesData(
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 10,
                    reservedSize: 50,
                    getTitlesWidget: (value, meta) {
                      return SizedBox(
                        width: 40,
                        child: Text(
                          value.toInt().toString(),
                          textAlign: TextAlign.right,
                          style: const TextStyle(fontSize: 10),
                        ),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  axisNameSize: 30, 
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: bottomInterval.toDouble(),
                    getTitlesWidget: (value, meta) {
                      int index = tempHistory.length - 1 - value.toInt();
                      if (index < 0 || index >= tempHistory.length) {
                        return const SizedBox();
                      }

                      final time = tempHistory[index].time;

                      return SideTitleWidget(
                        meta: meta,
                        child: Transform.rotate(
                          angle: -0.8, // rotate labels
                          child: Text(
                            // DateFormat('HH:mm:ss').format(time),  // Use this if you want sec aslo
                            DateFormat('HH:mm').format(time),  
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),
                      );
                    }
                  ),
                ),
              ),
              barGroups: List.generate(maxX, (i) {
                // final temp = i < tempHistory.length ? tempHistory[i].value : 0.0;
                // final humidity = i < humidityHistory.length ? humidityHistory[i].value : 0.0;
                final tempIndex = maxX - 1 - i;
                final humIndex = maxX - 1 - i;

                // final temp = tempIndex >= 0 ? tempHistory[tempIndex].value : 0.0;
                // final humidity = humIndex >= 0 ? humidityHistory[humIndex].value : 0.0;
                final temp =
                    (tempIndex >= 0 && tempIndex < tempHistory.length)
                        ? tempHistory[tempIndex].value
                        : 0.0;

                final humidity =
                    (humIndex >= 0 && humIndex < humidityHistory.length)
                        ? humidityHistory[humIndex].value
                        : 0.0;
                return BarChartGroupData(
                  x: i,
                  // x: maxX - i - 1,
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
          ),
        ),
      ),
    );
  }
}