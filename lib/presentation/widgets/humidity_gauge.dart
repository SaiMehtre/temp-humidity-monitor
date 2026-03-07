import 'dart:math';
import 'package:flutter/material.dart';

class HumidityGauge extends StatelessWidget {
  final double humidity;

  const HumidityGauge({
    super.key,
    required this.humidity,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      width: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [

          /// Background Circle
          SizedBox(
            height: 160,
            width: 160,
            child: CircularProgressIndicator(
              value: humidity / 100,
              strokeWidth: 12,
              backgroundColor: Colors.grey.shade300,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),

          /// Value Text
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.water_drop, color: Colors.blue, size: 30),
              Text(
                "${humidity.toStringAsFixed(0)}%",
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text("Humidity")
            ],
          ),
        ],
      ),
    );
  }
}