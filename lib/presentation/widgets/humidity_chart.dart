// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../providers/humidity_history_provider.dart';

// class HumidityChart extends ConsumerWidget {
//   const HumidityChart({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final data = ref.watch(humidityHistoryProvider);

//     if (data.length < 2) {
//       return const SizedBox(
//         height: 250,
//         child: Center(child: Text("Collecting humidity data...")),
//       );
//     }

//     return SizedBox(
//       height: 250,
//       child: LineChart(
//         LineChartData(
//           minY: 0,
//           maxY: 100,
//           gridData: FlGridData(show: true),
//           borderData: FlBorderData(show: true),
//           lineBarsData: [
//             LineChartBarData(
//               spots: List.generate(
//                 data.length,
//                 (index) => FlSpot(index.toDouble(), data[index]),
//               ),
//               isCurved: true,
//               dotData: FlDotData(show: true),
//               barWidth: 3,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }