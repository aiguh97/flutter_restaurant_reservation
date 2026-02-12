import 'package:flutter/material.dart';
import 'package:restoguh/data/datasources/auth_local_datasource.dart';
import 'package:restoguh/presentation/auth/pages/login_page.dart';

class AuthGuard {
  static Future<bool> checkAuth(BuildContext context) async {
    final authData = await AuthLocalDatasource().getAuthData();

    // ❌ token tidak ada
    if (authData == null || authData.token == null) {
      _logout(context);
      return false;
    }

    return true;
  }

  static Future<void> _logout(BuildContext context) async {
    await AuthLocalDatasource().removeAuthData();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }
}
