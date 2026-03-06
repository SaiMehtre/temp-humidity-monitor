import 'package:flutter/material.dart';
import '../../data/models/alert_type.dart';

class ThermometerTube extends StatelessWidget {
  final double temperature;
  final AlertType alertType;

  const ThermometerTube({
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

    final level = normalize();
    final color = getColor();

    return SizedBox(
      height: 340,
      child: Stack(
        alignment: Alignment.center,
        children: [

          /// SCALE MARKS
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                11,
                (i) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 30,
                      height: 2,
                      color: Colors.black45,
                    ),
                    // const SizedBox(width: 30),
                    Container(
                      width: 30,
                      height: 2,
                      color: Colors.black45,
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// OUTER TUBE
          Container(
            width: 90,
            height: 290,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black54, width: 4),
              borderRadius: BorderRadius.circular(40),
              color: Colors.white,
            ),
          ),

          /// MERCURY FILL
          Positioned(
            bottom: 35,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: 40,
              height: 240 * level,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),

          /// BULB
          Positioned(
            bottom: 0,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
                border: Border.all(color: Colors.black54, width: 4),
              ),
            ),
          ),

          /// TEMPERATURE TEXT
          Positioned(
            top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "${temperature.toStringAsFixed(1)} °C",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}