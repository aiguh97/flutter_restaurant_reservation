import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:restoguh/core/constants/variables.dart';
import 'package:restoguh/data/models/request/order_request_model.dart';
import 'package:http/http.dart' as http;
import 'auth_local_datasource.dart';

class OrderRemoteDatasource {
  Future<Either<String, int>> sendOrder(OrderRequestModel requestModel) async {
    final url = Uri.parse('${Variables.baseUrl}/api/orders');
    final authData = await AuthLocalDatasource().getAuthData();

    if (authData == null || authData.token == null) {
      return left('Sesi login berakhir');
    }

    try {
      // DEBUG: Pastikan jsonEncode tidak membungkus string yang sudah di-encode
      final bodyPayload = jsonEncode(requestModel.toJson());
      print('Sending Payload: $bodyPayload');

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer ${authData.token!}',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: bodyPayload,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);

        // Mencoba mengambil ID dari berbagai kemungkinan struktur Laravel
        final int? orderId =
            responseData['data']?['id'] ?? // Jika { "data": { "id": ... } }
            responseData['id'] ?? // Jika { "id": ... }
            responseData['data']?['order_id']; // Jika menggunakan order_id

        if (orderId == null) {
          // Log respon asli untuk memudahkan Anda melihat strukturnya di terminal
          print('Respon Server Tanpa ID: ${response.body}');
          return left('Gagal mendapatkan ID Order: Field id tidak ditemukan');
        }

        return right(orderId);
      } else {
        // Ambil pesan error spesifik dari Laravel validation
        final Map<String, dynamic> errorBody = jsonDecode(response.body);
        final String errorMessage =
            errorBody['message'] ?? 'Gagal membuat order';

        // Jika ada detail error per field
        final String detailedError = errorBody['errors'] != null
            ? errorBody['errors'].toString()
            : response.body;

        return left(
          'Error ${response.statusCode}: $errorMessage\n$detailedError',
        );
      }
    } catch (e) {
      return left('Terjadi kesalahan koneksi: $e');
    }
  }
}
