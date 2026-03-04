import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class AlertHistoryScreen extends StatelessWidget {
  const AlertHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('alerts');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Alert History"),
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box box, _) {
          if (box.isEmpty) {
            return const Center(child: Text("No alerts yet"));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final alert = box.getAt(index);

              final time = DateTime.parse(alert['time']);

              return ListTile(
                title: Text(alert['type']),
                subtitle: Text(
                    "${alert['value']}  •  ${DateFormat('dd MMM yyyy hh:mm a').format(time)}"),
              );
            },
          );
        },
      ),
    );
  }
}