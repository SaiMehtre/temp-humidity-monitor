import 'package:flutter/material.dart';
import '../widgets/temperature_chart.dart';
import '../widgets/humidity_chart.dart';

class GraphScreen extends StatelessWidget {
  const GraphScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sensor History")),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("Temperature History"),
              SizedBox(height: 10),
              TemperatureChart(),
              SizedBox(height: 30),
              Text("Humidity History"),
              SizedBox(height: 10),
              HumidityChart(),
            ],
          ),
        ),
      ),
    );
  }
}