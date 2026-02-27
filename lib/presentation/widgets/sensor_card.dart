import 'package:flutter/material.dart';
// import 'package:auto_size_text/auto_size_text.dart';
import '../../data/models/alert_type.dart';

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

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    if (widget.alertType != AlertType.normal) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant SensorCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.alertType != AlertType.normal) {
      _controller.repeat(reverse: true);
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color getBorderColor() {
    switch (widget.alertType) {
      case AlertType.low:
        return Colors.blue;
      case AlertType.high:
        return Colors.red;
      case AlertType.normal:
        return Colors.transparent;
    }
  }

  Color getBackgroundColor() {
    switch (widget.alertType) {
      case AlertType.low:
        return Colors.blue.shade50;
      case AlertType.high:
        return Colors.red.shade50;
      case AlertType.normal:
        return Colors.grey.shade200;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: getBackgroundColor(),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: getBorderColor()
                  .withOpacity(0.5 + (_controller.value * 0.5)),
              width: 2,
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: getBorderColor(),
                child: Icon(widget.icon, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  "${widget.title}\n${widget.value}",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}