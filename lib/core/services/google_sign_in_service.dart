import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        '148741705924-643t7e4fpe85n71s6ofn4airvt7hsri5.apps.googleusercontent.com',
    scopes: ['email', 'profile'],
  );

  /// Logout Google (hapus sesi Google)
  static Future<void> signOut() async {
    try {
      await _googleSignIn.signOut(); // Hapus session
      await _googleSignIn.disconnect(); // Hapus cached account
    } catch (e) {
      debugPrint('Google Sign-Out error: $e');
    }
  }

  /// Login Google dan ambil idToken
  static Future<String?> getIdToken() async {
    try {
      // Selalu force tampilkan chooser
      await _googleSignIn.signOut(); // Hapus session lama
      final account = await _googleSignIn
          .signIn(); // Akan tampil account chooser
      if (account == null) return null;

      final auth = await account.authentication;
      return auth.idToken;
    } catch (e) {
      debugPrint('Google Sign-In error: $e');
      return null;
    }
  }
}
