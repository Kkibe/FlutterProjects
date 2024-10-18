import 'package:flutter/material.dart';

import '../models/account.dart';
import '../screens/edit_account_screen.dart';
import '../services/auth_service.dart';

class AccountTile extends StatelessWidget {
  final Account account;
  final AuthService authService = AuthService();

  AccountTile({required this.account});

  Future<void> _deleteAccount(BuildContext context) async {
    await authService.deleteAccount(account);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Account deleted')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(account.name),
      subtitle: Text(account.issuer),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditAccountScreen(account: account),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _deleteAccount(context),
          ),
        ],
      ),
    );
  }
}
