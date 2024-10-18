import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../models/account.dart';
import '../services/auth_service.dart';
import '../widgets/account_tile.dart';
import 'add_account_screen.dart';
import './edit_account_screen.dart';
import '../utils/otp_generator.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService authService = AuthService();
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authenticator App'),
      ),
      body: FutureBuilder<List<Account>>(
        future: authService.getAccounts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return ListView(
                children: snapshot.data!.map((account) {
                  final otpCode = OTPGenerator.generateTOTPCode(account.secret);
                  return ListTile(
                    title: Text(account.name),
                    subtitle: Text('${account.issuer}\nOTP: $otpCode'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditAccountScreen(account: account),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            await authService.deleteAccount(account);
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            } else {
              return Center(child: Text('No accounts added.'));
            }
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddAccountScreen()),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}
