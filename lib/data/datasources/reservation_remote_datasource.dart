import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../core/constants/variables.dart';
import 'auth_local_datasource.dart';
import '../models/response/reservation_response_model.dart';

class ReservationRemoteDatasource {
  Future<Either<String, ReservationResponseModel>> createReservation({
    required int tableId,
    required int orderId,
    required String date,
    required String startTime,
    required String endTime,
  }) async {
    final authData = await AuthLocalDatasource().getAuthData();
    if (authData == null || authData.token == null) {
      return left('Sesi login tidak valid atau token tidak ditemukan');
    }
    final response = await http.post(
      Uri.parse('${Variables.baseUrl}/api/reservations'),
      headers: {
        'Authorization': 'Bearer ${authData.token}',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'table_id': tableId,
        'order_id': orderId,
        'date': date,
        'start_time': startTime,
        'end_time': endTime,
        'status': 'reserved', // <-- Tambahkan baris ini
      }),
    );

    if (response.statusCode == 201) {
      return right(
        ReservationResponseModel.fromJson(jsonDecode(response.body)),
      );
    } else {
      return left(response.body);
    }
  }
}
