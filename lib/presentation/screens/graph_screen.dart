
  import 'package:flutter/material.dart';
  import 'package:flutter_riverpod/flutter_riverpod.dart';

  import '../widgets/combined_chart.dart';
  import '../providers/temp_history_provider.dart';
  import '../providers/humidity_history_provider.dart';
  import '../../core/utils/csv_exporter.dart';

  class GraphScreen extends ConsumerWidget {
    GraphScreen({super.key});

    final GlobalKey chartKey = GlobalKey();

    @override
    Widget build(BuildContext context, WidgetRef ref) {
      final tempCount = ref.watch(temperatureHistoryProvider).length;
      final humidityCount = ref.watch(humidityHistoryProvider).length;

      return Scaffold(
        appBar: AppBar(
          title: const Text("Sensor History"),
          actions: [
            // CSV EXPORT
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: () async {
                final temp = ref.read(temperatureHistoryProvider);
                final humidity = ref.read(humidityHistoryProvider);

                final path = await CsvExporter.export(temp, humidity);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("CSV saved at $path"),duration: const Duration(seconds: 4),),
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // DATA COUNT
                  Text(
                    "Temp points: $tempCount | Humidity points: $humidityCount",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  // LEGEND
                  Row(
                    children: [
                      Container(width: 12, height: 12, color: Colors.red),
                      const SizedBox(width: 4),
                      const Text("Temperature"),
                      const SizedBox(width: 20),
                      Container(width: 12, height: 12, color: Colors.blue),
                      const SizedBox(width: 4),
                      const Text("Humidity"),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // GRAPH
                  Expanded(
                    child: RepaintBoundary(
                      key: chartKey,
                      child: InteractiveViewer(
                        minScale: 0.5,
                        maxScale: 3,
                        child: const CombinedBarChart(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }