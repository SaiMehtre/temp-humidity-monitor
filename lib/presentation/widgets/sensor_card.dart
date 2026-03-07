import 'package:flutter/material.dart';
import '../../data/models/alert_type.dart';
import 'thermometer_tube.dart';
import 'humidity_gauge.dart';

class SensorCard extends StatefulWidget {
  final String title;
  final String value;
  final IconData icon;
  final AlertType alertType;

  const SensorCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.alertType,
  });

  @override
  State<SensorCard> createState() => _SensorCardState();
}

class _SensorCardState extends State<SensorCard>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    this._controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    this._scaleAnimation = Tween<double>(begin: 1, end: 1.04).animate(
      CurvedAnimation(parent: this._controller, curve: Curves.easeInOut),
    );

    if (this.widget.alertType != AlertType.normal) {
      this._controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant SensorCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (this.widget.alertType != AlertType.normal) {
      this._controller.repeat(reverse: true);
    } else {
      this._controller.stop();
      this._controller.reset();
    }
  }

  @override
  void dispose() {
    this._controller.dispose();
    super.dispose();
  }

  Color getBorderColor() {
    switch (this.widget.alertType) {
      case AlertType.low:
        return Colors.orange;
      case AlertType.high:
        return Colors.red;
      case AlertType.normal:
        return Colors.grey.shade400;
    }
  }

  Color getBackgroundColor() {
    switch (this.widget.alertType) {
      case AlertType.low:
        return Colors.orange.shade50;
      case AlertType.high:
        return Colors.red.shade50;
      case AlertType.normal:
        return Colors.grey.shade100;
    }
  }

  double getTemperature() {
    return double.tryParse(
          this.widget.value.replaceAll(RegExp('[^0-9.-]'), ''),
        ) ??
        0;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: this._controller,
      builder: (context, child) {
        return Transform.scale(
          scale: this.widget.alertType == AlertType.normal
              ? 1
              : this._scaleAnimation.value,
          child: Container(
            padding: const EdgeInsets.all(16),
            constraints: const BoxConstraints(minHeight: 380),
            decoration: BoxDecoration(
              color: getBackgroundColor(),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: getBorderColor(),
                width: 2,
              ),
              boxShadow: [
                if (this.widget.alertType != AlertType.normal)
                  BoxShadow(
                    color: getBorderColor().withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 3,
                  )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                /// HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      this.widget.icon,
                      color: getBorderColor(),
                      size: 28,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      this.widget.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                /// SENSOR CONTENT
                /// SENSOR CONTENT
                if (this.widget.title == "Temperature")
                  Column(
                    children: [

                      IndustrialThermometer(
                        temperature: getTemperature(),
                        alertType: this.widget.alertType,
                      ),

                      const SizedBox(height: 20),

                      HumidityGauge(
                        humidity: 65,
                      ),

                    ],
                  )
                else
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: Text(
                      this.widget.value,
                      key: ValueKey(this.widget.value),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                const SizedBox(height: 20),

                /// STATUS LABEL
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: getBorderColor().withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    this.widget.alertType.name.toUpperCase(),
                    style: TextStyle(
                      color: getBorderColor(),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            )
          ),
        );
      },
    );
  }
}