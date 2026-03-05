import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import '../widgets/combined_chart.dart';
import '../providers/temp_history_provider.dart';
import '../providers/humidity_history_provider.dart';
import '../../core/utils/csv_exporter.dart';

class GraphScreen extends ConsumerWidget {
  const GraphScreen({super.key});

  static final ScreenshotController screenshotController =
      ScreenshotController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tempCount = ref.watch(temperatureHistoryProvider).length;
    final humidityCount = ref.watch(humidityHistoryProvider).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sensor History"),
        actions: [

          // 📥 CSV EXPORT
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () async {
              final temp = ref.read(temperatureHistoryProvider);
              final humidity = ref.read(humidityHistoryProvider);

              final path = await CsvExporter.export(temp, humidity);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("CSV saved at $path")),
              );
            },
          ),

          // 🖼 SAVE GRAPH IMAGE
          IconButton(
            icon: const Icon(Icons.image),
            onPressed: () async {
              final image = await screenshotController.capture();

              if (image != null) {
                await ImageGallerySaver.saveImage(image);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Graph saved to gallery")),
                );
              }
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

                // 📊 DATA COUNT
                Text(
                  "Temp points: $tempCount | Humidity points: $humidityCount",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                // 📊 LEGEND
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

                // 📈 GRAPH
                Expanded(
                  child: Screenshot(
                    controller: screenshotController,
                    child: InteractiveViewer(
                      minScale: 0.5,
                      maxScale: 3,
                      child: const CombinedChart(),
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