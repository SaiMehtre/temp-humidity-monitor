
  import 'package:flutter/material.dart';
  import 'package:flutter_riverpod/flutter_riverpod.dart';

  import '../widgets/combined_chart.dart';
  import '../providers/temp_history_provider.dart';
  import '../providers/humidity_history_provider.dart';
  import '../../core/utils/csv_exporter.dart';
  import '../../core/utils/excel_exporter.dart';
  import '../../core/utils/pdf_exporter.dart';

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
            // IconButton(
            //   icon: const Icon(Icons.download),
            //   onPressed: () async {
            //     final temp = ref.read(temperatureHistoryProvider);
            //     final humidity = ref.read(humidityHistoryProvider);

            //     final path = await CsvExporter.export(temp, humidity);

            //     ScaffoldMessenger.of(context).showSnackBar(
            //       SnackBar(content: Text("CSV saved at $path"),duration: const Duration(seconds: 4),),
            //     );
            //   },
            // ),
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: () async {

                final choice = await showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return SafeArea(
                      child: Wrap(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.table_chart),
                            title: const Text("Export Excel"),
                            onTap: () => Navigator.pop(context, "excel"),
                          ),
                          ListTile(
                            leading: const Icon(Icons.picture_as_pdf),
                            title: const Text("Export PDF"),
                            onTap: () => Navigator.pop(context, "pdf"),
                          ),
                          ListTile(
                            leading: const Icon(Icons.grid_on),
                            title: const Text("Export CSV"),
                            onTap: () => Navigator.pop(context, "csv"),
                          ),
                        ],
                      ),
                    );
                  },
                );

                final temp = ref.read(temperatureHistoryProvider);
                final humidity = ref.read(humidityHistoryProvider);

                String? path;

                if (choice == "excel") {
                  path = await ExcelExporter.export(temp, humidity);
                } 
                else if (choice == "pdf") {
                  path = await PdfExporter.export(temp, humidity);
                } 
                else if (choice == "csv") {
                  path = await CsvExporter.export(temp, humidity);
                }

                if (path != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("File saved at $path")),
                  );
                }
              },
            )
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

                  
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children:  [
                      _LegendItem(color: Colors.red, label: "Temperature"),
                      _LegendItem(color: Colors.blue, label: "Humidity"),
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
                        child: const ScrollableBarChart(),
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

  class _LegendItem extends StatelessWidget {
    final Color color;
    final String label;

    const _LegendItem({required this.color, required this.label});

    @override
    Widget build(BuildContext context) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 12, height: 12, color: color),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }
  }