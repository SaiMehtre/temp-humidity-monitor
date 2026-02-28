import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/providers/dashboard_provider.dart';
import '../widgets/sensor_card.dart';
import '../widgets/status_indicator.dart';
import 'package:intl/intl.dart';
import '../providers/threshold_provider.dart';
import '../../data/models/alert_type.dart';
import '../../data/services/alert_service.dart';
import '../../data/services/notification_service.dart';
import '../../presentation/providers/interval_provider.dart';
import '../../presentation/providers/alert_history_provider.dart';
import '../../data/models/alert_history.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends ConsumerState<DashboardScreen> {

  // bool _isAlertActive = false;

  @override
void initState() {
  super.initState();

  Future.microtask(() {
    ref.listen(dashboardProvider, (previous, next) {
      final threshold = ref.read(thresholdProvider);

      final isTempDanger =
          threshold.tempEnabled &&
          next.temperature >= threshold.tempMax;

      final isHumidityDanger =
          threshold.humidityEnabled &&
          next.humidity >= threshold.humidityMax;

      final now = DateTime.now();

      final tempSnoozed =
          AlertService.tempSnoozeUntil != null &&
          now.isBefore(AlertService.tempSnoozeUntil!);

      final humiditySnoozed =
          AlertService.humiditySnoozeUntil != null &&
          now.isBefore(AlertService.humiditySnoozeUntil!);

      bool triggered = false;

      // 🔥 TEMPERATURE ALERT
      if (isTempDanger && !tempSnoozed) {
        triggered = true;

        AlertService.startAlert();

        NotificationService.showAlert(
          "Temperature Alert",
          "Temp: ${next.temperature}°C",
        );

        ref.read(alertHistoryProvider.notifier).update((state) => [
              ...state,
              AlertHistory("Temperature", next.temperature, now)
            ]);
      }

      // 🔥 HUMIDITY ALERT
      if (isHumidityDanger && !humiditySnoozed) {
        triggered = true;

        AlertService.startAlert();

        NotificationService.showAlert(
          "Humidity Alert",
          "Humidity: ${next.humidity}%",
        );

        ref.read(alertHistoryProvider.notifier).update((state) => [
              ...state,
              AlertHistory("Humidity", next.humidity, now)
            ]);
      }

      // 🔕 Stop if no danger
      if (!isTempDanger && !isHumidityDanger) {
        AlertService.stopAlert();
      }

      print("TEMP: ${next.temperature}");
    });
  });
}

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(dashboardProvider);
    final threshold = ref.watch(thresholdProvider);

    AlertType getTempAlert() {
      if (!threshold.tempEnabled) return AlertType.normal;

      if (data.temperature < threshold.tempMin) {
        return AlertType.low;
      } else if (data.temperature > threshold.tempMax) {
        return AlertType.high;
      } else {
        return AlertType.normal;
      }
    }

    AlertType getHumidityAlert() {
      if (!threshold.humidityEnabled) return AlertType.normal;

      if (data.humidity < threshold.humidityMin) {
        return AlertType.low;
      } else if (data.humidity > threshold.humidityMax) {
        return AlertType.high;
      } else {
        return AlertType.normal;
      }
    }

    final tempAlertType = getTempAlert();
    final humidityAlertType = getHumidityAlert();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(dashboardProvider.notifier).refreshData();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              StatusIndicator(isOnline: data.isOnline),
              const SizedBox(height: 20),

              SensorCard(
                title: "Temperature",
                value: "${data.temperature.toStringAsFixed(1)} °C",
                icon: Icons.thermostat,
                alertType: tempAlertType,
              ),

              const SizedBox(height: 16),

              SensorCard(
                title: "Humidity",
                value: "${data.humidity.toStringAsFixed(1)} %",
                icon: Icons.water_drop,
                alertType: humidityAlertType,
              ),

              const SizedBox(height: 24),

              Text(
                "Last Updated: ${DateFormat('dd MMM yyyy, hh:mm a').format(data.lastUpdated)}",
              ),

              const SizedBox(height: 20),
              DropdownButton<int>(
                value: ref.watch(intervalProvider),
                items: const [
                  DropdownMenuItem(value: 30, child: Text("30 Seconds")),
                  DropdownMenuItem(value: 60, child: Text("1 Minute")),
                  DropdownMenuItem(value: 300, child: Text("5 Minutes")),
                ],
                onChanged: (value) {
                  ref.read(intervalProvider.notifier).state = value!;
                  ref.read(dashboardProvider.notifier).refreshData();
                },
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  AlertService.startAlert();
                },
                child: const Text("Test Sound"),
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  AlertService.snooze(5);
                },
                child: const Text("Snooze 5 Min"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}