import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
// import 'package:path_provider/path_provider.dart';
import '../../data/models/sensor_point.dart';

class PdfExporter {

  static Future<String> export(
      List<SensorPoint> temp, List<SensorPoint> humidity) async {

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Table.fromTextArray(
            headers: ["Time", "Temp", "Humidity"],
            data: List.generate(temp.length, (i) {
              return [
                temp[i].time.toIso8601String(),
                temp[i].value.toString(),
                humidity.length > i ? humidity[i].value.toString() : ""
              ];
            }),
          );
        },
      ),
    );

    // final directory = await getApplicationDocumentsDirectory();
    // final path = "${directory.path}/sensor_report.pdf";
    // final directory = Directory('/storage/emulated/0/Download');

    final directory = Directory('/storage/emulated/0/Download/temp_humidity');

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final path = "${directory.path}/sensor_report_$timestamp.pdf";

    final file = File(path);
    await file.writeAsBytes(await pdf.save());

    return path;
  }
}