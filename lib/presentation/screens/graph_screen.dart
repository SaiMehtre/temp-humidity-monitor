import 'package:flutter/material.dart';
import '../widgets/temperature_chart.dart';

class GraphScreen extends StatelessWidget {
  const GraphScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
  appBar: AppBar(title: const Text("Temperature History")),
  body: const Padding(
    padding: EdgeInsets.all(16),
    child: TemperatureChart(),
  ),
);
  }
}