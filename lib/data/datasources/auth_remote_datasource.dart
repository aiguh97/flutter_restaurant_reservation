import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter_pos_2/core/constants/variables.dart';
import 'package:flutter_pos_2/data/datasources/auth_local_datasource.dart';
import 'package:flutter_pos_2/data/models/response/auth_response_model.dart';
import 'package:http/http.dart' as http;

class AuthRemoteDatasource {
  Future<Either<String, AuthResponseModel>> login(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('${Variables.baseUrl}/api/login'),
      body: {'email': email, 'password': password},
    );
    if (response.statusCode == 200) {
      return right(AuthResponseModel.fromJson(response.body));
    } else {
      // Mengambil pesan error dari JSON jika tersedia
      final String message =
          jsonDecode(response.body)['message'] ?? 'Login Gagal';
      return left(message);
    }
  }

  // data/datasources/auth_remote_datasource.dart

  Future<Either<String, Map<String, dynamic>>> setup2FA() async {
    try {
      final authData = await AuthLocalDatasource().getAuthData();

      // Cek apakah token ada sebelum kirim request
      if (authData == null || authData.token == null) {
        return const Left("Sesi berakhir, silakan login kembali.");
      }

      final response = await http.get(
        Uri.parse('${Variables.baseUrl}/api/2fa/setup'),
        headers: {
          'Authorization': 'Bearer ${authData.token}',
          'Accept': 'application/json',
          'ngrok-skip-browser-warning': 'true', // Penting jika pakai Ngrok
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return Right(responseData['data']);
      } else {
        // Ambil pesan error dari Laravel jika ada
        final message =
            jsonDecode(response.body)['message'] ??
            "Gagal mengambil data setup 2FA";
        return Left(message);
      }
    } catch (e) {
      return Left("Terjadi kesalahan koneksi: $e");
    }
  }

  Future<Either<String, String>> enable2FA(String code) async {
    final authData = await AuthLocalDatasource().getAuthData();
    final response = await http.post(
      Uri.parse('${Variables.baseUrl}/api/2fa/enable'),
      headers: {
        'Authorization': 'Bearer ${authData!.token}',
        'Accept': 'application/json',
      },
      body: {'code': code},
    );

    if (response.statusCode == 200) {
      return const Right("2FA Enabled");
    } else {
      final message =
          jsonDecode(response.body)['message'] ?? "Gagal verifikasi";
      return Left(message);
    }
  }

  // lib/data/datasources/auth_remote_datasource.dart

  Future<Either<String, String>> disable2FA() async {
    try {
      final authData = await AuthLocalDatasource().getAuthData();
      final response = await http.post(
        Uri.parse('${Variables.baseUrl}/api/2fa/disable'),
        headers: {
          'Authorization': 'Bearer ${authData!.token}',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return const Right("2FA berhasil dinonaktifkan.");
      } else {
        final message =
            jsonDecode(response.body)['message'] ?? "Gagal menonaktifkan 2FA";
        return Left(message);
      }
    } catch (e) {
      return Left("Terjadi kesalahan: ${e.toString()}");
    }
  }

  Future<Either<String, String>> logout() async {
    final authData = await AuthLocalDatasource().getAuthData();

    // 🛡️ Tambahkan pengecekan null untuk authData dan token
    if (authData == null || authData.token == null) {
      return left('Sesi tidak ditemukan atau token kadaluwarsa');
    }

    final response = await http.post(
      Uri.parse('${Variables.baseUrl}/api/logout'),
      // ✅ Gunakan operator ! karena sudah dipastikan tidak null di atas
      headers: {
        'Authorization': 'Bearer ${authData.token!}',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return right(response.body);
    } else {
      return left(response.body);
    }
  }

  Future<Either<String, AuthResponseModel>> verify2FA(
    int userId,
    String code,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${Variables.baseUrl}/api/2fa/verify'),
        headers: {'Accept': 'application/json'},
        body: {'user_id': userId.toString(), 'code': code},
      );

      if (response.statusCode == 200) {
        return Right(AuthResponseModel.fromJson(response.body));
      } else {
        final message =
            jsonDecode(response.body)['message'] ?? 'Verifikasi gagal';
        return Left(message);
      }
    } catch (e) {
      return Left('Terjadi kesalahan koneksi: $e');
    }
  }
}
