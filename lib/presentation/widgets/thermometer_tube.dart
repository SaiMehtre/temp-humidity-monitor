import 'package:flutter/material.dart';
import '../../data/models/alert_type.dart';

class IndustrialThermometer extends StatelessWidget {
  final double temperature;
  final AlertType alertType;

  const IndustrialThermometer({
    super.key,
    required this.temperature,
    required this.alertType,
  });

  double normalize() {
    const min = -20;
    const max = 100;

    double value = (temperature - min) / (max - min);

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
    final mercuryColor = getColor();

    return SizedBox(
      width: 130,
      height: 420,
      child: Stack(
        alignment: Alignment.center,
        children: [

          /// SCALE MARKS
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  11,
                  (i) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(width: 22, height: 2, color: Colors.black45),
                      Container(width: 22, height: 2, color: Colors.black45),
                    ],
                  ),
                ),
              ),
            ),
          ),

          /// GLASS TUBE
          Container(
            width: 30,
            height: 340,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade500, width: 3),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.9),
                  Colors.grey.shade200,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),

            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [

                /// MERCURY
                AnimatedContainer(
                  duration: const Duration(milliseconds: 700),
                  width: 18,
                  height: 340 * percent,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [
                        mercuryColor.withOpacity(0.7),
                        mercuryColor,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),

                /// GLASS SHINE
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 6,
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.7),
                          Colors.transparent,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// BULB
          Positioned(
            bottom: 10,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    mercuryColor.withOpacity(0.8),
                    mercuryColor,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: mercuryColor.withOpacity(0.6),
                    blurRadius: 14,
                    spreadRadius: 4,
                  )
                ],
              ),
            ),
          ),

          /// TEMPERATURE TEXT
          Positioned(
            top: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "${temperature.toStringAsFixed(1)} °C",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}