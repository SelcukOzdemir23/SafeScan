# SafeScan QR

A Flutter application for scanning QR codes and checking URL safety.

## Features

- Real-time QR code scanning with camera
- Upload QR code images from gallery
- Manual URL input option
- URL safety checking
- Support for both light and dark themes
- Animated UI for better user experience
- Proper error handling and user feedback

## Getting Started

### Prerequisites

- Flutter SDK (Latest stable version)
- Dart SDK
- Android Studio / VS Code
- iOS or Android device/emulator

### Installation

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the app

## Usage

### Scanning QR Codes
- Point your camera at a QR code within the scanning frame
- The app will automatically detect and process the QR code
- View the safety analysis results

### Alternative Input Methods
- Tap the "Enter URL" button to:
  - Manually enter a URL
  - Upload a QR code image from your gallery

### Safety Check Results
- View detailed safety analysis
- See warnings for potentially unsafe URLs
- Open safe URLs directly from the app

## Privacy & Permissions

The app requires the following permissions:
- Camera access for QR code scanning
- Photo library access for uploading QR images

## Contributing

Feel free to contribute to this project by submitting issues or pull requests.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
