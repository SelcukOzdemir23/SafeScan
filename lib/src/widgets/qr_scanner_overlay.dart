import 'package:flutter/material.dart';

class QRScannerOverlay extends StatelessWidget {
  final Color overlayColour;
  final double scanWindowSizeRatio; // e.g., 0.6 means 60% of the shortest side
  final double borderRadius;

  const QRScannerOverlay({
    super.key,
    this.overlayColour = Colors.black54, // Default overlay color
    this.scanWindowSizeRatio = 0.7, // Default scan window size
    this.borderRadius = 12.0, // Default border radius
  });

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final screenSize = MediaQuery.of(context).size;
    // Determine the shortest side to make the scan window square-ish
    final shortestSide = screenSize.width < screenSize.height ? screenSize.width : screenSize.height;
    // Calculate the size of the transparent scan window
    final scanWindowSize = shortestSide * scanWindowSizeRatio;

    return Stack(
      children: [
        // Background overlay
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            overlayColour,
            BlendMode.srcOut, // This creates the 'hole' effect
          ),
          child: Stack(
            children: [
              // Full screen opaque container
              Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent, // Will be affected by ColorFiltered
                  backgroundBlendMode: BlendMode.dstOut, // Important for hole effect
                ),
              ),
              // The transparent scan window area
              Align(
                alignment: Alignment.center,
                child: Container(
                   width: scanWindowSize,
                   height: scanWindowSize,
                  decoration: BoxDecoration(
                    color: Colors.red, // This color doesn't matter due to BlendMode.dstOut
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Optional: Add a border around the scan window
        Align(
          alignment: Alignment.center,
          child: Container(
             width: scanWindowSize,
             height: scanWindowSize,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withOpacity(0.7), // White border
                width: 2.0, // Border width
              ),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
        ),
         // Optional: Add corner markers
         Align(
           alignment: Alignment.center,
           child: SizedBox(
             width: scanWindowSize + 40, // Slightly larger than window for corners
             height: scanWindowSize + 40,
             child: CustomPaint(
               painter: CornerPainter(
                 borderColor: Theme.of(context).primaryColor, // Use theme color
                 borderWidth: 4.0,
                 cornerRadius: borderRadius,
               ),
             ),
           ),
         ),
      ],
    );
  }
}


// Custom painter for drawing the corner markers
class CornerPainter extends CustomPainter {
  final Color borderColor;
  final double borderWidth;
  final double cornerRadius;
  final double cornerLength; // Length of the corner lines

  CornerPainter({
    required this.borderColor,
    required this.borderWidth,
    required this.cornerRadius,
    this.cornerLength = 25.0, // Default corner line length
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = borderColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    // Adjust calculations if using cornerRadius > 0
    double effectiveRadius = cornerRadius > borderWidth / 2 ? cornerRadius - borderWidth / 2 : 0;


    // Top Left Corner
    path.moveTo(effectiveRadius + cornerLength, borderWidth / 2);
    path.lineTo(effectiveRadius, borderWidth / 2);
    // Add arc if radius is significant
    if (effectiveRadius > 0) {
       path.arcToPoint(
         Offset(borderWidth / 2, effectiveRadius),
         radius: Radius.circular(effectiveRadius),
         clockwise: false,
       );
    } else {
       path.lineTo(borderWidth / 2, borderWidth / 2); // Sharp corner if no radius
    }
    path.lineTo(borderWidth / 2, effectiveRadius + cornerLength);


    // Top Right Corner
    path.moveTo(size.width - effectiveRadius - cornerLength, borderWidth / 2);
    path.lineTo(size.width - effectiveRadius, borderWidth / 2);
    if (effectiveRadius > 0) {
      path.arcToPoint(
        Offset(size.width - borderWidth / 2, effectiveRadius),
        radius: Radius.circular(effectiveRadius),
        clockwise: false,
      );
    } else {
       path.lineTo(size.width - borderWidth / 2, borderWidth / 2);
    }
    path.lineTo(size.width - borderWidth / 2, effectiveRadius + cornerLength);

    // Bottom Left Corner
    path.moveTo(borderWidth / 2, size.height - effectiveRadius - cornerLength);
    path.lineTo(borderWidth / 2, size.height - effectiveRadius);
     if (effectiveRadius > 0) {
      path.arcToPoint(
        Offset(effectiveRadius, size.height - borderWidth / 2),
        radius: Radius.circular(effectiveRadius),
        clockwise: false,
      );
    } else {
      path.lineTo(borderWidth / 2, size.height - borderWidth / 2);
    }
    path.lineTo(effectiveRadius + cornerLength, size.height - borderWidth / 2);


    // Bottom Right Corner
    path.moveTo(size.width - effectiveRadius - cornerLength, size.height - borderWidth / 2);
    path.lineTo(size.width - effectiveRadius, size.height - borderWidth / 2);
     if (effectiveRadius > 0) {
       path.arcToPoint(
         Offset(size.width - borderWidth / 2, size.height - effectiveRadius),
         radius: Radius.circular(effectiveRadius),
         clockwise: false,
       );
     } else {
        path.lineTo(size.width - borderWidth / 2, size.height - borderWidth / 2);
     }
    path.lineTo(size.width - borderWidth / 2, size.height - effectiveRadius - cornerLength);


    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
