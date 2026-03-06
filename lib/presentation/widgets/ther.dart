// IndustrialThermometer(
//   temperature: 42.5,
//   dangerTemp: 35,
// )

import 'package:flutter/material.dart';

class IndustrialThermometer extends StatelessWidget {
  final double temperature;
  final double minTemp;
  final double maxTemp;
  final double dangerTemp;

  const IndustrialThermometer({
    super.key,
    required this.temperature,
    this.minTemp = 0,
    this.maxTemp = 100,
    this.dangerTemp = 60,
  });

  @override
  Widget build(BuildContext context) {
    double percent =
        ((temperature - minTemp) / (maxTemp - minTemp)).clamp(0.0, 1.0);

    Color mercuryColor =
        temperature >= dangerTemp ? Colors.red : Colors.blue;

    return SizedBox(
      width: 120,
      height: 420,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(width: 18, height: 2, color: Colors.black45),
                    Container(width: 18, height: 2, color: Colors.black45),
                  ],
                ),
              ),
            ),
          ),

          /// GLASS TUBE
          Container(
            width: 26,
            height: 340,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade400, width: 3),
              color: Colors.grey.shade100,
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 700),
                width: 16,
                height: 340 * percent,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: mercuryColor,
                ),
              ),
            ),
          ),

          /// BOTTOM BULB
          Positioned(
            bottom: 10,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: mercuryColor,
                boxShadow: [
                  BoxShadow(
                    color: mercuryColor.withOpacity(0.4),
                    blurRadius: 10,
                    spreadRadius: 3,
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
                horizontal: 10,
                vertical: 4,
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}