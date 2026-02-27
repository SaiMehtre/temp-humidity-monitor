import 'package:flutter/material.dart';

class StatusIndicator extends StatefulWidget {
  final bool isOnline;

  const StatusIndicator({super.key, required this.isOnline});

  @override
  State<StatusIndicator> createState() => _StatusIndicatorState();
}

class _StatusIndicatorState extends State<StatusIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.6, end: 1.2).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isOnline ? Colors.green : Colors.red;

    return Row(
      children: [
        ScaleTransition(
          scale: _animation,
          child: Icon(Icons.circle, size: 12, color: color),
        ),
        const SizedBox(width: 8),
        Text(
          widget.isOnline ? "ONLINE" : "OFFLINE",
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}