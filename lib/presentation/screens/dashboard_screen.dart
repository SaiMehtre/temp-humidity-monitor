import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/providers/dashboard_provider.dart';
import '../widgets/sensor_card.dart';
import '../widgets/status_indicator.dart';
import 'package:intl/intl.dart';
import '../providers/threshold_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(dashboardProvider);
    final threshold = ref.watch(thresholdProvider);

    final bool tempAlert = threshold.tempEnabled &&
    (data.temperature < threshold.tempMin ||
        data.temperature > threshold.tempMax);

    final bool humidityAlert = threshold.humidityEnabled &&
        (data.humidity < threshold.humidityMin ||
            data.humidity > threshold.humidityMax);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isLargeScreen = constraints.maxWidth > 600;

          return RefreshIndicator(
            onRefresh: () async {
              ref.read(dashboardProvider.notifier).refreshData();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StatusIndicator(isOnline: data.isOnline),
                  const SizedBox(height: 20),

                  isLargeScreen
                      ? Row(
                          children: [
                            Expanded(
                              child: SensorCard(
                                title: "Temperature",
                                value: "${data.temperature.toStringAsFixed(1)} °C",
                                icon: Icons.thermostat,
                                color: tempAlert ? Colors.red : Colors.orange,
                                isAlert: tempAlert,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: SensorCard(
                                title: "Humidity",
                                value: "${data.humidity.toStringAsFixed(1)} %",
                                icon: Icons.water_drop,
                                color: humidityAlert ? Colors.red : Colors.blue,
                                isAlert: humidityAlert,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            SensorCard(
                              title: "Temperature",
                              value: "${data.temperature.toStringAsFixed(1)} °C",
                              icon: Icons.thermostat,
                              color: tempAlert ? Colors.red : Colors.orange,
                              isAlert: tempAlert,
                            ),
                            const SizedBox(height: 16),
                            SensorCard(
                              title: "Humidity",
                              value: "${data.humidity.toStringAsFixed(1)} %",
                              icon: Icons.water_drop,
                              color: humidityAlert ? Colors.red : Colors.blue,
                              isAlert: humidityAlert,
                            ),
                          ],
                        ),

                  const SizedBox(height: 24),

                  Text(
                    "Last Updated: ${DateFormat('dd MMM yyyy, hh:mm a').format(data.lastUpdated)}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}