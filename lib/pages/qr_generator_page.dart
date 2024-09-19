// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart'; 

class QRGeneratorPage extends StatefulWidget {
  const QRGeneratorPage({super.key});

  @override
  State<QRGeneratorPage> createState() => _QRGeneratorPageState();
}

class _QRGeneratorPageState extends State<QRGeneratorPage> {
  final TextEditingController _controller = TextEditingController();
  String qrData = '';
  GlobalKey globalKey = GlobalKey();
  bool _isGenerating = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Generate QR Code')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Enter Data (URL, Contact, Wi-Fi, Phone, or Text)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: _isGenerating ? Colors.blueGrey : Colors.blue,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isGenerating = _isGenerating;
                      qrData = _processInput(_controller.text);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                  ),
                  child: const Text('Generate QR Code', style: TextStyle(color: Colors.white),),
                ),
              ),
              const SizedBox(height: 20),
              if (qrData.isNotEmpty && qrData != "Invalid Input")
                Column(
                  children: [
                    AnimatedOpacity(
                      opacity: qrData.isNotEmpty ? 1.0 : 0.0,
                      duration: const Duration(microseconds: 500),
                      child: RepaintBoundary(
                        key: globalKey,
                        child: QrImageView(
                          data: qrData,
                          version: QrVersions.auto,
                          size: 200.0,
                          // ignore: deprecated_member_use
                          foregroundColor: isDarkMode ? Colors.white : Colors.black, 
                          backgroundColor: isDarkMode ? Colors.black : Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                  color: _isGenerating ? Colors.blueGrey : Colors.blue,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                      child: ElevatedButton(
                        onPressed: () async {
                          await _exportQRCode();
                        },
                         style: ElevatedButton.styleFrom(
                         backgroundColor: Colors.transparent,
                         elevation: 0,
                         padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                  ),
                        child: const Text('Save QR Code as Image',style: TextStyle(color: Colors.white),),
                      ),
                    ),
                    const SizedBox(height: 20),
                    AnimatedContainer(
                       duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                      color: _isGenerating ? Colors.blueGrey : Colors.blue,
                      borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          _shareQRCode(qrData); 
                        },
                         style: ElevatedButton.styleFrom(
                         backgroundColor: Colors.transparent,
                         elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                                        ),
                        child: const Text('Share QR Code',style: TextStyle(color: Colors.white),),
                      ),
                    ),
                  ],
                ),
              if (qrData == "Invalid Input")
                const Text(
                  'Invalid Input Format. Please enter a valid URL, contact information, Wi-Fi details, phone number, or text.',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _processInput(String input) {
    if (_isValidURL(input)) {
      // It's a URL
      return input;
    } else if (_isContactInfo(input)) {
      // Parse contact information
      return _generateVCardFromInput(input);
    } else if (_isWiFiInfo(input)) {
      // Parse Wi-Fi details
      return _generateWiFiQRFromInput(input);
    } else if (_isPhoneNumber(input)) {
      // Format phone number QR code
      return _generatePhoneNumberQRFromInput(input);
    } else {
      // Treat the input as plain text
      return input;
    }
  }

  // URL validation
  bool _isValidURL(String input) {
    final urlPattern = RegExp(r'^(http|https):\/\/[^\s]+$');
    return urlPattern.hasMatch(input);
  }

  // Contact Info validation
  bool _isContactInfo(String input) {
    return input.contains('Name:') && input.contains('Phone:');
  }

  // Wi-Fi Info validation
  bool _isWiFiInfo(String input) {
    return input.contains('SSID:') && input.contains('Password:');
  }

  // Phone Number validation
  bool _isPhoneNumber(String input) {
    final phonePattern = RegExp(r'^\+?[0-9]{7,15}$'); // Matches international phone numbers
    return phonePattern.hasMatch(input);
  }

  // Generate vCard from input
  String _generateVCardFromInput(String input) {
    final nameMatch = RegExp(r'Name:\s*([^\n,]+)').firstMatch(input);
    final phoneMatch = RegExp(r'Phone:\s*([^\n,]+)').firstMatch(input);

    String name = nameMatch?.group(1) ?? '';
    String phone = phoneMatch?.group(1) ?? '';

  return '''
   BEGIN:VCARD
   VERSION:3.0
   FN:$name
   TEL:$phone
   END:VCARD
    ''';
   }

  // Generate Wi-Fi QR from input
  String _generateWiFiQRFromInput(String input) {
    final ssidMatch = RegExp(r'SSID:\s*([^\n,]+)').firstMatch(input);
    final passwordMatch = RegExp(r'Password:\s*([^\n,]+)').firstMatch(input);

    String ssid = ssidMatch?.group(1) ?? '';
    String password = passwordMatch?.group(1) ?? '';

    return 'WIFI:S:$ssid;T:WPA;P:$password;;';
  }

  // Generate Phone Number QR from input
  String _generatePhoneNumberQRFromInput(String input) {
    return 'tel:$input'; 
  }

  Future<void> _exportQRCode() async {
    try {
      // Request storage permission
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        // Handle the case when permission is not granted
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Storage permission denied')),
        );
        return;
      }

      // Capture the widget as an image
      RenderRepaintBoundary boundary = globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Get the directory to save the file
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/qr_code.png';
      final file = File(path);
      await file.writeAsBytes(pngBytes);

      // Notify the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('QR Code saved to $path')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving QR Code: $e')),
      );
    }
  }

  Future<void> _shareQRCode(String data) async {
    try {
      // Capture the widget as an image
      RenderRepaintBoundary boundary = globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Get the temporary directory
      final directory = await getTemporaryDirectory();
      final path = '${directory.path}/qr_code.png';
      final file = File(path);
      await file.writeAsBytes(pngBytes);

      // Share the image
      await Share.shareXFiles([XFile(path)], text: 'Check out my QR code!');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sharing QR Code: $e')),
      );
    }
  }
}
