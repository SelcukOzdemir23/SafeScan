import 'package:flutter/material.dart';
import 'package:safescan_flutter/src/models/safety_result.dart'; // Import the model with extensions

class SafetyIndicator extends StatelessWidget {
  final SafetyStatus status;
  final double size;

  const SafetyIndicator({
    super.key,
    required this.status,
    this.size = 100.0, // Default size for the indicator
  });

  @override
  Widget build(BuildContext context) {
    // Use the properties defined in the SafetyStatus extension
    final Color color = status.color;
    final IconData iconData = status.icon;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15), // Light background color based on status
        shape: BoxShape.circle, // Circular background
        border: Border.all(
          color: color, // Border color matches status
          width: 3.0,
        ),
      ),
      child: Center(
        child: Icon(
          iconData,
          color: color, // Icon color matches status
          size: size * 0.5, // Make icon proportional to the container size
        ),
      ),
    );
  }
}
