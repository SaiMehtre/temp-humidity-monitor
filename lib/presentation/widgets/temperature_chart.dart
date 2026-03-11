// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../providers/temp_history_provider.dart';
// // import '../../data/models/sensor.point.dart';


// class TemperatureChart extends ConsumerWidget {
//   const TemperatureChart({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final data = ref.watch(temperatureHistoryProvider);

//     if (data.length <= 0) {
//       return const SizedBox(
//         height: 250,
//         child: Center(child: Text("Collecting data...")),
//       );
//     }

//               print("Chart Data Length: ${data.length}");
//     return SizedBox(
//       height: 250,
//       child: LineChart(
//         LineChartData(
//           minY: 0,
//           maxY: 100, // IoT temp range ke hisab se set karo
//           gridData: FlGridData(show: true),
//           titlesData: FlTitlesData(show: true),
//           borderData: FlBorderData(show: true),
//           lineBarsData: [
//             LineChartBarData(
//               spots: List.generate(
//                 data.length,
//                 (index) => FlSpot(index.toDouble(), data[index]),
//               ),
//               isCurved: true,
//               dotData: FlDotData(show: true), // dots visible karo
//               barWidth: 3,
//             ),
//           ],          
//         ),
//       )
//     );
//   }
// }