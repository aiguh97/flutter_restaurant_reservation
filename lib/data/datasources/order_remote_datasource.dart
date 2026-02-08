import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:restoguh/core/constants/variables.dart';
import 'package:restoguh/data/models/request/order_request_model.dart';
import 'package:http/http.dart' as http;

import 'auth_local_datasource.dart';

class OrderRemoteDatasource {
  // Ubah return type menjadi int agar kita dapat order_id
  Future<Either<String, int>> sendOrder(OrderRequestModel requestModel) async {
    final url = Uri.parse('${Variables.baseUrl}/api/orders');
    final authData = await AuthLocalDatasource().getAuthData();

    if (authData == null || authData.token == null) {
      return left('Sesi login berakhir');
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer ${authData.token!}',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: requestModel.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        // Ambil order_id dari response API Laravel
        return right(responseData['order_id']);
      } else {
        return left('Gagal membuat order: ${response.body}');
      }
    } catch (e) {
      return left('Terjadi kesalahan koneksi');
    }
  }
}
