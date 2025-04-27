# **App Name**: SafeScan

## Core Features:

- QR Code Scanning: Implement a QR code scanner using the device's camera. Display a live camera feed and an overlay to guide the user during scanning.
- URL Safety Check and Display: Extract the URL from the scanned QR code and display the safety status (Safe, Unsafe, Warning, Unknown) using distinct visual indicators.

## Style Guidelines:

- Primary color: White (#FFFFFF) for a clean and modern look.
- Secondary color: Light gray (#F0F0F0) for backgrounds and subtle UI elements.
- Accent color: Teal (#008080) for highlights and key actions.
- Clear and readable font for all text elements.
- Simple, modern icons to represent different safety statuses.
- Clean and intuitive layout with a focus on usability.

## Original User Request:
Please provide a detailed plan, code structure, and guidance for developing a Flutter mobile application with Firebase integration.

**App Title:** QR Code Link Safety Checker

**App Description:**
Develop a cross-platform mobile application using Flutter that allows users to scan QR codes. The primary function is to extract any embedded URL from the scanned QR code and then perform a safety check on that URL using a reputable external safety service (e.g., Google Safe Browse API or similar). The app should clearly display the safety status of the link to the user (e.g., Safe, Unsafe/Malicious, Warning, Unknown).

**Core Functionality Requirements:**

1.  **QR Code Scanning:**
    * Utilize the device's camera to scan QR codes in real-time.
    * Implement a live camera feed with an overlay to guide the user.
    * Handle camera permissions gracefully, asking the user for access if needed.
    * Support various QR code formats.

2.  **URL Extraction & Validation:**
    * Parse the data obtained from the scanned QR code.
    * Validate if the parsed data is a valid URL format.
    * Handle cases where the QR code contains non-URL data or is empty.

3.  **Link Safety Check:**
    * This is the core feature. The app needs to integrate with an external API service to check the safety of the extracted URL.
    * **Crucial:** The call to the external safety API **must** be handled securely. It is recommended to route this API call through a backend service (like Firebase Cloud Functions) to protect API keys and potentially implement caching or rate limiting.
    * Process the API response to determine the safety status.

4.  **Result Display:**
    * Present the safety check result clearly to the user on a dedicated screen.
    * Use distinct visual indicators (colors, icons, text) for different safety statuses (e.g., green for Safe, red for Unsafe, yellow for Warning).
    * Display the original scanned URL.
    * Optionally provide a disclaimer that the safety check is not foolproof.

5.  **User Interface (UI) / User Experience (UX):**
    * Clean and intuitive design.
    * Easy-to-use scanning interface.
    * Loading indicator while the safety check is in progress.
    * Clear navigation between screens (Scanner -> Result).

**Technical Stack:**

* **Frontend:** Flutter (Dart)
* **Backend (for API calls):** Firebase Cloud Functions (Node.js/TypeScript recommended)

**Firebase Services Integration:**

1.  **Firebase Cloud Functions:**
    * **Purpose:** To securely handle calls to the external URL safety check API. This prevents exposing API keys in the client-side code.
    * Implement an HTTPS Callable Function that receives the URL from the Flutter app and calls the external safety API.
    * Process the API response within the function and return the safety status back to the Flutter app.

2.  **Firestore or Realtime Database (Optional but Recommended):**
    * **Purpose:** To store a history of scanned QR codes and their safety status for the user.
    * Store relevant information like the scanned URL, the safety result, and the timestamp of the scan.
    * Allow users to view their scan history.

3.  **Firebase Crashlytics:**
    * **Purpose:** For real-time crash reporting to monitor the stability of the Flutter application.

4.  **Firebase Performance Monitoring:**
    * **Purpose:** To track the performance of key operations, such as QR scanning duration and the latency of the safety check API call (via Cloud Functions).

5.  **Firebase Analytics (Optional):**
    * **Purpose:** To understand user behavior, such as the number of scans performed or features used.

**Best Practices and Considerations:**

1.  **Security:**
    * **API Key Protection:** Absolutely vital to use Firebase Cloud Functions to proxy calls to the external safety API. Never embed API keys directly in the Flutter client code.
    * **Data Privacy:** If storing scan history, inform the user and ensure data is handled securely according to privacy regulations.

2.  **Performance:**
    * Optimize QR scanning to be fast and responsive.
    * Handle the safety check API call asynchronously to avoid blocking the UI.
    * Implement loading indicators during the API call.
    * Consider basic caching in the Cloud Function for frequently checked URLs (if the safety API's terms allow).

3.  **Error Handling:**
    * Gracefully handle cases where:
        * Camera permissions are denied.
        * No QR code is detected in the frame.
        * The scanned data is not a valid URL.
        * Network errors occur (client or Cloud Function).
        * The external safety API returns an error or unexpected response.
        * Firebase Cloud Function calls fail.
    * Provide informative error messages to the user.

4.  **User Education & Disclaimers:**
    * Add a clear disclaimer that the safety check is based on third-party data and might not be 100% accurate or protect against all types of threats.
    * Educate the user on why the app needs camera permission.

5.  **Code Structure:**
    * Organize the Flutter project using a standard pattern (e.g., MVC, MVVM, Provider, BLoC) for maintainability.
    * Separate UI logic from business logic.
    * Structure Cloud Functions logically (e.g., per endpoint or feature).

6.  **Third-Party Libraries:**
    * Identify and recommend reputable Flutter packages for QR code scanning (e.g., `mobile_scanner`, `qr_code_scanner`).
    * Identify and recommend packages for making HTTP requests if needed client-side (though most API calls should be server-side).

7.  **Testing:**
    * Outline the importance of testing: unit tests for logic, widget tests for UI components, and integration tests for the full flow (scanning -> function call -> result).

**Prompt Output Request:**

Please provide:
1.  A suggested project structure for the Flutter application.
2.  Key code snippets or conceptual outlines for:
    * Handling camera permissions.
    * Implementing the QR scanning widget.
    * Extracting and validating the URL.
    * Making the call to the Firebase Cloud Function.
    * Implementing the Firebase Cloud Function to call an external safety API (conceptual outline mentioning using `axios` or similar).
    * Displaying results based on the function's response.
3.  A list of recommended Flutter packages.
4.  Guidance on setting up Firebase Cloud Functions for this purpose.
5.  Notes on implementing the best practices mentioned above.

---

This prompt provides a comprehensive overview, allowing the AI assistant to generate a detailed and structured response covering the necessary steps and considerations for building this application effectively and securely.
  