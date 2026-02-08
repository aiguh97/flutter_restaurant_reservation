import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:restoguh/core/constants/variables.dart';
import 'package:restoguh/data/datasources/auth_local_datasource.dart';
import 'package:restoguh/data/models/response/auth_response_model.dart';
import 'package:http/http.dart' as http;

class AuthRemoteDatasource {
  static const _headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  // ===================== LOGIN =====================
  // Helper untuk menangani error agar tidak terjadi error type Map vs String
  String _handleError(dynamic body, String defaultMessage) {
    if (body is Map && body['message'] != null) {
      final message = body['message'];
      if (message is Map) {
        // Jika message adalah object (seperti error validasi Laravel), ambil error pertama
        return message.values.first is List
            ? message.values.first[0].toString()
            : message.values.first.toString();
      }
      return message.toString();
    }
    return defaultMessage;
  }

  // ===================== LOGIN =====================
  Future<Either<String, AuthResponseModel>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${Variables.baseUrl}/api/login'),
        headers: _headers,
        body: jsonEncode({'email': email, 'password': password}),
      );

      final body = jsonDecode(response.body);

      // Gunakan AuthResponseModel.fromMap karena jsonDecode menghasilkan Map
      if (response.statusCode == 200) {
        final authResponse = AuthResponseModel.fromMap(body);
        return Right(authResponse);
      } else {
        // Jika 401/403 tapi isinya 2FA_REQUIRED, tetap kirim ke Right agar diproses Bloc
        if (body['message'] == '2FA_REQUIRED') {
          return Right(AuthResponseModel.fromMap(body));
        }
        return Left(_handleError(body, 'Login gagal'));
      }
    } catch (e) {
      return Left('Terjadi kesalahan koneksi: ${e.toString()}');
    }
  }

  // ===================== REGISTER =====================
  Future<Either<String, AuthResponseModel>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${Variables.baseUrl}/api/register'),
        headers: _headers,
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        }),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(AuthResponseModel.fromJson(body));
      } else {
        return Left(body['message'] ?? 'Register gagal');
      }
    } catch (e) {
      return Left('Terjadi kesalahan koneksi: $e');
    }
  }

  // ===================== GOOGLE AUTH =====================
  Future<Either<String, AuthResponseModel>> loginWithGoogle(
    String idToken,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${Variables.baseUrl}/api/auth/google'),
        headers: _headers,
        body: jsonEncode({'id_token': idToken}),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return Right(AuthResponseModel.fromJson(body));
      } else {
        return Left(body['message'] ?? 'Login Google gagal');
      }
    } catch (e) {
      return Left('Terjadi kesalahan koneksi: $e');
    }
  }

  // ===================== 2FA SETUP =====================
  Future<Either<String, Map<String, dynamic>>> setup2FA() async {
    try {
      final authData = await AuthLocalDatasource().getAuthData();

      if (authData?.token == null) {
        return const Left('Sesi berakhir, silakan login kembali.');
      }

      final response = await http.get(
        Uri.parse('${Variables.baseUrl}/api/2fa/setup'),
        headers: {
          ..._headers,
          'Authorization': 'Bearer ${authData!.token}',
          'ngrok-skip-browser-warning': 'true',
        },
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return Right(body['data']);
      } else {
        return Left(body['message'] ?? 'Gagal setup 2FA');
      }
    } catch (e) {
      return Left('Terjadi kesalahan koneksi: $e');
    }
  }

  // ===================== ENABLE 2FA =====================
  Future<Either<String, String>> enable2FA(String code) async {
    try {
      final authData = await AuthLocalDatasource().getAuthData();

      if (authData?.token == null) {
        return const Left('Sesi berakhir, silakan login kembali.');
      }

      final response = await http.post(
        Uri.parse('${Variables.baseUrl}/api/2fa/enable'),
        headers: {..._headers, 'Authorization': 'Bearer ${authData!.token}'},
        body: jsonEncode({'code': code}),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return const Right('2FA berhasil diaktifkan');
      } else {
        return Left(body['message'] ?? 'Gagal verifikasi 2FA');
      }
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }

  // ===================== DISABLE 2FA =====================
  Future<Either<String, String>> disable2FA() async {
    try {
      final authData = await AuthLocalDatasource().getAuthData();

      if (authData?.token == null) {
        return const Left('Sesi berakhir, silakan login kembali.');
      }

      final response = await http.post(
        Uri.parse('${Variables.baseUrl}/api/2fa/disable'),
        headers: {..._headers, 'Authorization': 'Bearer ${authData!.token}'},
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return const Right('2FA berhasil dinonaktifkan');
      } else {
        return Left(body['message'] ?? 'Gagal menonaktifkan 2FA');
      }
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }

  // ===================== LOGOUT =====================
  Future<Either<String, String>> logout() async {
    try {
      final authData = await AuthLocalDatasource().getAuthData();

      if (authData?.token == null) {
        return const Left('Token tidak ditemukan');
      }

      final response = await http.post(
        Uri.parse('${Variables.baseUrl}/api/logout'),
        headers: {..._headers, 'Authorization': 'Bearer ${authData!.token}'},
      );

      if (response.statusCode == 200) {
        return const Right('Logout berhasil');
      } else {
        return const Left('Logout gagal');
      }
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }

  // ===================== VERIFY 2FA =====================
  // Update juga method verify2FA
  // ===================== VERIFY 2FA =====================
  Future<Either<String, AuthResponseModel>> verify2FA(
    int userId,
    String code,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${Variables.baseUrl}/api/2fa/verify'),
        headers: _headers,
        body: jsonEncode({'user_id': userId, 'code': code}),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return Right(AuthResponseModel.fromMap(body));
      } else {
        return Left(_handleError(body, 'Verifikasi 2FA gagal'));
      }
    } catch (e) {
      return Left('Koneksi Gagal: ${e.toString()}');
    }
  }
}
