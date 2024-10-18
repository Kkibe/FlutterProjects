import 'package:flutter/material.dart';
import '../models/account.dart';
import '../services/auth_service.dart';

class EditAccountScreen extends StatefulWidget {
  final Account account;

  // ignore: use_key_in_widget_constructors
  EditAccountScreen({required this.account});

  @override
  _EditAccountScreenState createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController issuerController = TextEditingController();
  final TextEditingController secretController = TextEditingController();
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.account.name;
    issuerController.text = widget.account.issuer;
    secretController.text = widget.account.secret;
  }

  Future<void> _saveAccount() async {
    final updatedAccount = Account(
      name: nameController.text,
      issuer: issuerController.text,
      secret: secretController.text,
    );
    await authService.updateAccount(widget.account, updatedAccount);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Account Name'),
            ),
            TextField(
              controller: issuerController,
              decoration: InputDecoration(labelText: 'Issuer'),
            ),
            TextField(
              controller: secretController,
              decoration: InputDecoration(labelText: 'Secret'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveAccount,
              child: Text('Save Account'),
            ),
          ],
        ),
      ),
    );
  }
}
