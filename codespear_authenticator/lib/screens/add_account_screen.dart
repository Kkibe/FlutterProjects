import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:provider/provider.dart';

import '../models/account.dart';
import '../services/auth_service.dart';

class AddAccountScreen extends StatefulWidget {
  @override
  _AddAccountScreenState createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController issuerController = TextEditingController();
  final TextEditingController secretController = TextEditingController();
  final AuthService authService = AuthService();

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      controller!.pauseCamera();
      controller!.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        _parseScannedData(scanData.code);
      });
    });
  }

  void _parseScannedData(String? data) {
    if (data != null) {
      // Assuming the data is in the format otpauth://totp/Issuer:Name?secret=SECRET
      Uri uri = Uri.parse(data);
      setState(() {
        nameController.text = uri.pathSegments.last.split(':').last;
        issuerController.text = uri.pathSegments.last.split(':').first;
        secretController.text = uri.queryParameters['secret']!;
      });
    }
  }

  Future<void> _saveAccount() async {
    final account = Account(
      name: nameController.text,
      issuer: issuerController.text,
      secret: secretController.text,
    );
    await authService.saveAccount(account);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Account Name'),
                  ),
                  TextField(
                    controller: issuerController,
                    decoration: const InputDecoration(labelText: 'Issuer'),
                  ),
                  TextField(
                    controller: secretController,
                    decoration: const InputDecoration(labelText: 'Secret'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveAccount,
                    child: const Text('Save Account'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
