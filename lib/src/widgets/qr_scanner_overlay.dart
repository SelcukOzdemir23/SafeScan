
import 'package:flutter/material.dart';

class QRScannerOverlay extends StatelessWidget {
  const QRScannerOverlay({
    Key? key,
    this.overlayColor = Colors.black54, // Semi-transparent black
    this.borderColor = Colors.teal, // Accent color
    this.borderRadius = 12.0,
    this.borderWidth = 4.0,
    this.cutOutSizeFactor = 0.7, // Factor of the shorter side
  }) : super(key: key);

  final Color overlayColor;
  final Color borderColor;
  final double borderRadius;
  final double borderWidth;
  final double cutOutSizeFactor; // Controls the size of the transparent square

  @override
  Widget build(BuildContext context) {
    // Calculate the size of the cut-out area based on the shortest dimension
    // to ensure it's always visible and reasonably sized.
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double shorterSide = screenWidth < screenHeight ? screenWidth : screenHeight;
    double cutOutSize = shorterSide * cutOutSizeFactor;

    return Stack(
      children: [
        // Darkened overlay
        ColorFiltered(
          colorFilter: ColorFilter.mode(overlayColor, BlendMode.srcOut),
          child: Stack(
            children: [
              // Full screen container with transparent background
              Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent, // Needs to be transparent
                  backgroundBlendMode: BlendMode.dstOut,
                ),
              ),
              // Centered transparent cut-out area
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: cutOutSize,
                  height: cutOutSize,
                  decoration: BoxDecoration(
                    color: Colors.black, // Will be cleared by the ColorFiltered widget
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Border around the cut-out area
        Center(
          child: Container(
            width: cutOutSize,
            height: cutOutSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: borderColor,
                width: borderWidth,
              ),
            ),
          ),
        ),
         // Optional: Add guiding text
         Align(
           alignment: Alignment.bottomCenter,
           child: Padding(
             padding: const EdgeInsets.only(bottom: 60.0), // Adjust padding as needed
             child: Text(
               'Align QR code within the frame',
               style: TextStyle(
                 color: Colors.white.withOpacity(0.8),
                 fontSize: 16.0,
                 ),
                textAlign: TextAlign.center,
             ),
           ),
         ),
      ],
    );
  }
}
