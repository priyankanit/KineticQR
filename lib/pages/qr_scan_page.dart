// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class QRScanPage extends StatefulWidget {
  const QRScanPage({super.key});
  @override
  State<QRScanPage> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  String scannedData = '';
  bool isFrontCamera = false;
  bool isFlashOn = false;

   final List<String> harmfulDomains = ['example.com', 'malicious.com'];

@override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      controller!.pauseCamera();
    }
    controller?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
      actions: [
          IconButton(
            icon: const Icon(Icons.switch_camera_outlined),
            onPressed: () {
              // Toggle between front and back cameras
              if (controller != null) {
                controller!.flipCamera();
                setState(() {
                  isFrontCamera = !isFrontCamera;
                });
              }
            },
          ),
  IconButton(
    icon: Icon(isFlashOn ? Icons.flash_off : Icons.flash_on),
    onPressed: () {
      setState(() {
        isFlashOn = isFlashOn;
      });
      controller?.toggleFlash(); 
    },
  ),


        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.blue,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
               child: scannedData.isNotEmpty
                  ? Column(
                      children: [
                        const Text(
                          'Scanned Data:',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          scannedData,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        if (_isValidURL(scannedData)) ...[
                          ElevatedButton(
                            onPressed: () => _openURL(scannedData),
                            child: const Text('Open URL'),
                          ),
                        ]
                      ],
                    )
                  : const Text('Scan a QR code'),
            ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        scannedData = scanData.code!;

        // Automatically stop camera when QR code is detected
        controller.pauseCamera();

        // Process URL (if any)
        if (_isValidURL(scannedData)) {
          if (_isHarmfulURL(scannedData)) {
            _showSnackBar('Warning: This URL might be harmful!');
          } else {
          _showSnackBar('QR Code detected! Click "Open URL" to view it.');
        }
      }
    });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  // Function to check if the scanned data is a URL
  bool _isValidURL(String data) {
    const urlPattern = r"^(http|https):\/\/[\w\-_]+(\.[\w\-_]+)+[/#?]?.*$";
    return RegExp(urlPattern).hasMatch(data);
  }
 bool _isHarmfulURL(String url) {
    return harmfulDomains.any((domain) => url.contains(domain));
  }

  // Function to open URL in browser
  void _openURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      _showSnackBar('Could not launch URL');
    }
  }

  // Show snackbar for notifications
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

