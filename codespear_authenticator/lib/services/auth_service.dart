import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

import '../models/account.dart';

class AuthService {
  final storage = FlutterSecureStorage();

  Future<void> saveAccount(Account account) async {
    final accounts = await getAccounts();
    accounts.add(account);
    await _saveAccounts(accounts);
  }

  Future<void> updateAccount(Account oldAccount, Account newAccount) async {
    final accounts = await getAccounts();
    final index = accounts.indexWhere((acc) => acc.secret == oldAccount.secret);
    if (index != -1) {
      accounts[index] = newAccount;
      await _saveAccounts(accounts);
    }
  }

  Future<void> deleteAccount(Account account) async {
    final accounts = await getAccounts();
    accounts.removeWhere((acc) => acc.secret == account.secret);
    await _saveAccounts(accounts);
  }

  Future<List<Account>> getAccounts() async {
    final jsonString = await storage.read(key: 'accounts');
    if (jsonString != null) {
      final List<dynamic> jsonData = json.decode(jsonString);
      return jsonData.map((json) => Account.fromJson(json)).toList();
    }
    return [];
  }

  Future<void> _saveAccounts(List<Account> accounts) async {
    final jsonString =
        json.encode(accounts.map((acc) => acc.toJson()).toList());
    await storage.write(key: 'accounts', value: jsonString);
  }
}
