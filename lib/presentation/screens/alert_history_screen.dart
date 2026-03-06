import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

ValueNotifier<String> selectedFilter = ValueNotifier("All");

class AlertHistoryScreen extends StatelessWidget {
  const AlertHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('alerts');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Alert History"),
        actions: [
          ValueListenableBuilder<String>(
            valueListenable: selectedFilter,
            builder: (context, value, _) {
              return DropdownButton<String>(
                value: value,
                underline: const SizedBox(),
                items: ["All", "Temperature", "Humidity"]
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (val) {
                  if (val != null) selectedFilter.value = val;
                },
              );
            },
          ),
          const SizedBox(width: 10)
        ],
      ),

      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box box, _) {

          if (box.isEmpty) {
            return const Center(child: Text("No alerts yet"));
          }

          final alerts = box.values.toList();

          return ValueListenableBuilder<String>(
            valueListenable: selectedFilter,
            builder: (context, filter, _) {

              List filteredAlerts = alerts;

              if (filter != "All") {
                filteredAlerts =
                    alerts.where((alert) => alert.type == filter).toList();
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: filteredAlerts.length,
                itemBuilder: (context, index) {

                  final alert = filteredAlerts[index];

                  final color = alert.type == "Temperature"
                      ? Colors.red
                      : Colors.blue;

                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),

                    child: ListTile(

                      leading: CircleAvatar(
                        backgroundColor: color.withOpacity(0.2),
                        child: Icon(
                          Icons.warning,
                          color: color,
                        ),
                      ),

                      title: Text(
                        alert.type,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      subtitle: Text(
                        "${alert.value}  •  ${DateFormat('dd MMM yyyy hh:mm a').format(alert.time)}",
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}