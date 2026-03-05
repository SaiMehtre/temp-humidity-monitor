import 'dart:io';
import 'package:csv/csv.dart';
// import 'package:path_provider/path_provider.dart';

import '../../data/models/sensor_point.dart';

class CsvExporter {
  static Future<String> export(
    List<SensorPoint> temp,
    List<SensorPoint> humidity,
  ) async {
    List<List<dynamic>> rows = [];

    rows.add(["Time", "Temperature", "Humidity"]);

    for (int i = 0; i < temp.length; i++) {
      rows.add([
        temp[i].time.toIso8601String(),
        temp[i].value,
        humidity.length > i ? humidity[i].value : ""
      ]);
    }

    String csvData = const ListToCsvConverter().convert(rows);

    // final directory = await getApplicationDocumentsDirectory();
    // final path = "${directory.path}/sensor_data.csv";

    // final file = File(path);
    // await file.writeAsString(csvData);

    // return path;

    final path = "/storage/emulated/0/Download/sensor_data.csv";

    final file = File(path);
    await file.writeAsString(csvData);

    return path;
  }
}