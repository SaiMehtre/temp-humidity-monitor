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

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends ConsumerState<DashboardScreen> {

  bool _isAlertActive = false;

  @override
  void initState() {
    super.initState();

    // 🔥 IMPORTANT: microtask lagao to avoid ref error
    Future.microtask(() {
      ref.listen(dashboardProvider, (previous, next) {
        final threshold = ref.read(thresholdProvider);

        final isTempDanger =
            threshold.tempEnabled &&
            next.temperature >= threshold.tempMax;

        final isHumidityDanger =
            threshold.humidityEnabled &&
            next.humidity >= threshold.humidityMax;

        final isDanger = isTempDanger || isHumidityDanger;

        if (isDanger && !_isAlertActive) {
          _isAlertActive = true;

          AlertService.startAlert();

          NotificationService.showAlert(
            " Alert!",
            "Temp: ${next.temperature}°C  Humidity: ${next.humidity}%",
          );
        }

        if (!isDanger && _isAlertActive) {
          _isAlertActive = false;
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

              ElevatedButton(
                onPressed: () {
                  AlertService.startAlert();
                },
                child: const Text("Test Sound"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}