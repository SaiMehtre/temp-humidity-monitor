import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import '../../data/models/sensor_point.dart';

class CsvExporter {

  static Future<String> export(
    List<SensorPoint> temp,
    List<SensorPoint> humidity,
  ) async {

    List<List<dynamic>> rows = [];

    rows.add(["Time","Temperature","Humidity"]);

    for (int i = 0; i < temp.length; i++) {
      rows.add([
        DateFormat('yyyy-MM-dd HH:mm:ss').format(temp[i].time.toLocal()),
        temp[i].value,
        humidity.length > i ? humidity[i].value : ""
      ]);
    }

    String csvData = const ListToCsvConverter().convert(rows);

    final directory = await getExternalStorageDirectory();

    final path = "${directory!.path}/sensor_data.csv";

    final file = File(path);

    await file.writeAsString(csvData);

    return path;
  }
}