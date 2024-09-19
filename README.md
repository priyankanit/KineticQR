# KineticQR

 This is a simple Flutter application to generate QR codes from user inputs such as URLs, contact info, Wi-Fi details, etc. Users can save or share the generated QR code.

 The task was to develop a Flutter application named kineticQR that allows users to scan and generate QR
 codes. The application should be user-friendly, efficient, and provide a seamless experience on
 both Android and iOS platforms.

 # Follow these points for designing

 1. Scan QR Codes
 ● Implement a feature that allows users to scan QR codes and barcodes using the
 device's camera.
 ● Theapplication should automatically detect and process the QR code without requiring
 the user to press any additional buttons.
 ● Display the scanned information in a readable format. If the QR code contains a URL,
 provide the option to open it in a browser.
 ● Provide support for scanning QR codes from various surfaces such as screens, posters,
 or product packaging.

 2. Create Custom QR Codes
 ● Implement a feature that enables users to generate QR codes based on different types
 of data inputs:
 ○ URLs(e.g., websites, YouTube videos)
 ○ Text (e.g., messages, notes)
 ○ Contact information (e.g., vCards)
 ○ Wi-Fi network details (e.g., SSID and password)
 ● Allow users to export the generated QR codes as images (e.g., PNG or JPG).
 ● Implement a sharing functionality to easily share the generated QR codes via messaging
 apps, email, or social media.
 Note: For guidance on generating QR codes in Flutter, you may refer to this article on Medium.

# Rules to follow

1. UI/UX Design
Simplicity: The interface should prioritize simplicity and accessibility. Limit unnecessary clutter and provide only essential features on the main screen.
Use clear labels, icons, and buttons with enough spacing to avoid misclicks.
Implement visual feedback (e.g., button press animations, loading indicators) for interactive elements.
Consistency: Maintain a consistent style throughout the app, including fonts, colors, and UI components. Ensure that navigation is intuitive, and users can easily understand how to move between screens.
User Flow: Design the user flow to minimize the number of taps or steps needed to achieve a goal. For example, if a feature requires multiple steps, guide the user through with clear call-to-action buttons and progress indicators.
Colors and Typography:
Use a visually appealing color palette with good contrast for readability.
Ensure that important actions (e.g., saving, sharing) are emphasized using color.
Use easy-to-read fonts and ensure proper text hierarchy (e.g., headings, body text).
2. Performance
Responsiveness: Make sure the app is responsive and adjusts to various screen sizes and orientations. Ensure it runs smoothly on both low-end and high-end devices.
Use proper image and asset sizes to prevent performance lag.
Optimize network calls by implementing caching, lazy loading, and background tasks where needed.
Test the app on different devices/emulators to check the performance across multiple platforms.
3. Documentation and Code Comments

# Features
Generate QR codes from text, URLs, or contact details.
Save QR codes as an image.
Share QR codes with others.

# How to Run the App
Prerequisites:
Flutter 3.0 and above
Dart SDK
Android/iOS Emulator or a physical device
Steps to run:
Clone the repository:
git clone <https://github.com/priyankanit/KineticQR.git>
cd KineticQR

Install dependencies:
flutter pub get
Run the app on an emulator or a device:
flutter run

# Code Structure
main.dart: Entry point of the application.
QRGeneratorPage.dart: UI logic for generating and saving the QR code.
QRScanPage.dart: UI logic for scanning QR codes.
HomePage.dart: UI logic to navigate to the specific pages. 

# Dependencies
qr_code_scanner for scanning QR codes.
qr_flutter for generating QR codes.
path_provider for saving images.
permission_handler for handling storage permissions.
share_plus for sharing QR codes.