// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:safescan_flutter/main.dart'; // Import your main app file

void main() {
  testWidgets('App starts and shows ScannerScreen title', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SafeScanApp());

    // Verify that the ScannerScreen AppBar title is present.
    // This assumes ScannerScreen is the initial screen.
    expect(find.text('SafeScan'), findsOneWidget);

    // Example: Verify no result text is initially shown (adjust finder as needed)
    expect(find.text('Scan Result'), findsNothing);

    // You can add more tests here, e.g., simulating button taps,
    // checking for specific widgets after actions, etc.
    // Example: Find the permission message initially if permissions not granted
    // expect(find.text('Permission Required'), findsOneWidget); // This depends on test setup
  });
}
