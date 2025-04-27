
import 'package:flutter/material.dart';
import 'package:safescan_flutter/src/models/safety_result.dart';

class SafetyIndicator extends StatelessWidget {
  final SafetyStatus status;
  final double size;

  const SafetyIndicator({
    super.key,
    required this.status,
    this.size = 80.0, // Default size
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.15), // Light background based on status
        shape: BoxShape.circle,
        border: Border.all(
          color: status.color,
          width: 2.0,
        ),
      ),
      child: Icon(
        status.icon,
        color: status.color,
        size: size * 0.5, // Icon size relative to container
      ),
    );
  }
}
