import 'package:flutter/material.dart';
import '../../data/models/alert_type.dart';

class HumidityGauge extends StatelessWidget {
  final double humidity;
  final AlertType alertType;

  const HumidityGauge({
    super.key,
    required this.humidity,
    required this.alertType,
  });

  double normalize() {
    const min = 0;
    const max = 100;

    double value = (humidity - min) / (max - min);

    if (value < 0) value = 0;
    if (value > 1) value = 1;

    return value;
  }

  Color getColor() {
    switch (alertType) {
      case AlertType.high:
        return Colors.red;
      case AlertType.low:
        return Colors.orange;
      case AlertType.normal:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final percent = normalize();
    final gaugeColor = getColor();

    return SizedBox(
      height: 180,
      width: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [

          /// Gauge
          SizedBox(
            height: 160,
            width: 160,
            child: CircularProgressIndicator(
              value: percent,
              strokeWidth: 12,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(gaugeColor),
            ),
          ),

          /// Value
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.water_drop, color: gaugeColor, size: 30),
              Text(
                "${humidity.toStringAsFixed(0)}%",
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text("Humidity"),
            ],
          ),
        ],
      ),
    );
  }
}