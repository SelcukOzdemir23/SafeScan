# SafeScan - Flutter QR Code Safety Checker

This is a Flutter mobile application designed to scan QR codes, extract URLs, and check their safety status using a backend service.

## Features

-   QR Code Scanning using the device camera.
-   URL Extraction and Validation.
-   URL Safety Check via a backend API call.
-   Display of safety status (Safe, Unsafe, Warning, Unknown) with clear visual indicators.
-   Handles camera permissions gracefully.

## Getting Started

### Prerequisites

1.  **Flutter SDK:** Ensure you have Flutter installed. Follow the [official Flutter installation guide](https://docs.flutter.dev/get-started/install).
2.  **IDE:** Android Studio (with Flutter plugin) or Visual Studio Code (with Flutter extension).
3.  **Emulator/Device:** An Android emulator/device or iOS simulator/device to run the app.
4.  **Backend Endpoint:** This application requires a backend service to perform the actual URL safety check (e.g., using Google Safe Browsing API).
    *   You need to deploy a simple backend (like a Firebase Cloud Function, Next.js API route, Node.js server, etc.) that securely calls the safety API.
    *   The Flutter app will call *your* backend endpoint.
    *   Update the `_baseUrl` in `lib/src/services/url_safety_service.dart` to point to your deployed backend endpoint. **Do not call external safety APIs directly from the Flutter app to protect API keys.**

### Setup

1.  **Clone the repository:**
    ```bash
    git clone <your-repository-url>
    cd safescan_flutter
    ```
2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Configure Backend URL:**
    *   Open `lib/src/services/url_safety_service.dart`.
    *   Modify the `_baseUrl` variable to point to your running backend endpoint. Use the correct IP address for local testing (e.g., `10.0.2.2` for Android Emulator, `localhost` or `127.0.0.1` for iOS Simulator/physical devices on the same network).
4.  **Run the app:**
    *   Connect a device or start an emulator/simulator.
    *   Run the app using:
        ```bash
        flutter run
        ```

## Project Structure

```
lib/
├── main.dart               # App entry point
└── src/
    ├── config/
    │   └── theme.dart      # App theme definition
    ├── features/
    │   ├── scanner/
    │   │   └── scanner_screen.dart # QR code scanning screen
    │   └── result/
    │       └── result_screen.dart  # URL safety result display screen
    ├── models/
    │   └── safety_result.dart # Data model for safety results (enum, class)
    ├── services/
    │   └── url_safety_service.dart # Service to call the backend API
    ├── utils/
    │   ├── constants.dart    # App-wide constants (if any)
    │   └── validators.dart   # Utility functions (e.g., URL validation)
    └── widgets/
        ├── qr_scanner_overlay.dart # Visual overlay for the scanner
        └── safety_indicator.dart   # Widget to display safety status visually
```

## Key Libraries Used

*   **`mobile_scanner`**: For QR code scanning using the device camera.
*   **`http`**: For making network requests to the backend API.
*   **`permission_handler`**: For requesting and checking camera permissions.
*   **`url_launcher`**: (Optional) For opening the scanned URL in a browser if deemed safe.

## Important Considerations

*   **Backend Security:** The core logic of checking the URL against a safety API (like Google Safe Browsing) **must** reside in a secure backend service. Never embed API keys directly in the Flutter app.
*   **Error Handling:** The app includes basic error handling for network issues and permission denials. Robust error handling is crucial for a production app.
*   **User Experience:** The UI aims for clarity with distinct visual indicators for safety statuses. Loading states and feedback are provided during the safety check.
*   **Disclaimer:** A disclaimer is included on the results screen reminding users that safety checks are not foolproof.
