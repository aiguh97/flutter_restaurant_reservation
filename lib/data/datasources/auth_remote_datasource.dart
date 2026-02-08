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
      final data = AuthResponseModel.fromJson(response.body);
      return right(data);
    } else {
      // Mengambil pesan error dari JSON jika tersedia
      final String message =
          jsonDecode(response.body)['message'] ?? 'Login Gagal';
      return left(message);
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
