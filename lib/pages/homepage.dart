import 'package:flutter/material.dart';
import 'package:kineticqr/pages/qr_generator_page.dart';

import 'qr_scan_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('KineticQR')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const QRScanPage()));
              },
              child: const Text('Scan QR Code', style: TextStyle(color: Colors.white),),
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const QRGeneratorPage()));
              },
              child: const Text('Generate QR Code', style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }
}
