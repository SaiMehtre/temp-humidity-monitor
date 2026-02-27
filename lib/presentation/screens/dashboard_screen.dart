import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/providers/dashboard_provider.dart';
import '../widgets/sensor_card.dart';
import '../widgets/status_indicator.dart';
import 'package:intl/intl.dart';
import '../providers/threshold_provider.dart';
import '../../data/models/alert_type.dart';
import '../../data/services/alert_service.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends ConsumerState<DashboardScreen> {

      // AlertType _previousTempAlert = AlertType.normal;
      // AlertType _previousHumidityAlert = AlertType.normal;

  @override
  void initState() {
    super.initState();

    // ref.listen(dashboardProvider, (previous, next) {
    //   final threshold = ref.read(thresholdProvider);

    //   AlertType getTempAlert() {
    //     if (!threshold.tempEnabled) return AlertType.normal;

    //     if (next.temperature < threshold.tempMin) {
    //       return AlertType.low;
    //     } else if (next.temperature > threshold.tempMax) {
    //       return AlertType.high;
    //     } else {
    //       return AlertType.normal;
    //     }
    //   }

    //   AlertType getHumidityAlert() {
    //     if (!threshold.humidityEnabled) return AlertType.normal;

    //     if (next.humidity < threshold.humidityMin) {
    //       return AlertType.low;
    //     } else if (next.humidity > threshold.humidityMax) {
    //       return AlertType.high;
    //     } else {
    //       return AlertType.normal;
    //     }
    //   }

    //   final currentTempAlert = getTempAlert();
    //   final currentHumidityAlert = getHumidityAlert();

    //   // 🚨 Trigger only when state changes from normal → alert
    //   if ((_previousTempAlert == AlertType.normal &&
    //           currentTempAlert != AlertType.normal) ||
    //       (_previousHumidityAlert == AlertType.normal &&
    //           currentHumidityAlert != AlertType.normal)) {
    //     AlertService.triggerAlert();
    //   }

    //   _previousTempAlert = currentTempAlert;
    //   _previousHumidityAlert = currentHumidityAlert;
    // });
  }

  @override
  Widget build(BuildContext context) {

    ref.listen(dashboardProvider, (previous, next) {
  final threshold = ref.read(thresholdProvider);

  AlertType getTempAlert(double temp) {
    if (!threshold.tempEnabled) return AlertType.normal;

    if (temp < threshold.tempMin) return AlertType.low;
    if (temp > threshold.tempMax) return AlertType.high;
    return AlertType.normal;
  }

  AlertType getHumidityAlert(double humidity) {
    if (!threshold.humidityEnabled) return AlertType.normal;

    if (humidity < threshold.humidityMin) return AlertType.low;
    if (humidity > threshold.humidityMax) return AlertType.high;
    return AlertType.normal;
  }

  final prevTemp = previous != null
      ? getTempAlert(previous.temperature)
      : AlertType.normal;

  final currentTemp = getTempAlert(next.temperature);

  final prevHumidity = previous != null
      ? getHumidityAlert(previous.humidity)
      : AlertType.normal;

  final currentHumidity = getHumidityAlert(next.humidity);

  if ((prevTemp == AlertType.normal &&
          currentTemp != AlertType.normal) ||
      (prevHumidity == AlertType.normal &&
          currentHumidity != AlertType.normal)) {
    AlertService.triggerAlert();
  }
});
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
                                alertType: tempAlertType,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: SensorCard(
                                title: "Humidity",
                                value: "${data.humidity.toStringAsFixed(1)} %",
                                icon: Icons.water_drop,
                                alertType: humidityAlertType,
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
                              alertType: tempAlertType,
                            ),
                            const SizedBox(height: 16),
                            SensorCard(
                              title: "Humidity",
                              value: "${data.humidity.toStringAsFixed(1)} %",
                              icon: Icons.water_drop,
                              alertType: humidityAlertType,
                            ),
                          ],
                        ),

                  const SizedBox(height: 24),

                  Text(
                    "Last Updated: ${DateFormat('dd MMM yyyy, hh:mm a').format(data.lastUpdated)}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),

//                   ElevatedButton(
//   onPressed: () {
//     AlertService.triggerAlert();
//   },
//   child: Text("Test Sound"),
// )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}