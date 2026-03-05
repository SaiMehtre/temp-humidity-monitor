import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import '../../data/models/sensor_point.dart';

class ExcelExporter {
  static Future<String> export(
      List<SensorPoint> temp, List<SensorPoint> humidity) async {

    var excel = Excel.createExcel();
    Sheet sheet = excel['SensorData'];

    sheet.appendRow(["Time", "Temperature", "Humidity"]);

    for (int i = 0; i < temp.length; i++) {
      sheet.appendRow([
        temp[i].time.toIso8601String(),
        temp[i].value,
        humidity.length > i ? humidity[i].value : ""
      ]);
    }

    final directory = await getApplicationDocumentsDirectory();
    final path = "${directory.path}/sensor_data.xlsx";

    File(path)
      ..createSync(recursive: true)
      ..writeAsBytesSync(excel.encode()!);

    return path;
  }
}