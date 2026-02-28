import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/alert_history_provider.dart';

class AlertHistoryScreen extends ConsumerWidget {
  const AlertHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(alertHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Alert History"),
      ),
      body: history.isEmpty
          ? const Center(
              child: Text("No Alerts Yet"),
            )
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];

                return ListTile(
                  title: Text("${item.type} Alert"),
                  subtitle: Text(
                    "${item.value} at ${item.time.toLocal()}",
                  ),
                );
              },
            ),
    );
  }
}