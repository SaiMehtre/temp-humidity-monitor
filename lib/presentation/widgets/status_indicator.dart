import 'package:flutter/material.dart';

class StatusIndicator extends StatelessWidget {
  final bool isOnline;

  const StatusIndicator({super.key, required this.isOnline});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.circle,
          size: 12,
          color: isOnline ? Colors.green : Colors.red,
        ),
        const SizedBox(width: 8),
        Text(
          isOnline ? "ONLINE" : "OFFLINE",
          style: TextStyle(
            color: isOnline ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}