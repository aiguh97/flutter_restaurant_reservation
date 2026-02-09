import 'dart:convert';

import 'package:restoguh/data/datasources/auth_local_datasource.dart';
import 'package:restoguh/data/models/response/qris_response_model.dart';
import 'package:restoguh/data/models/response/qris_status_response_model.dart';
import 'package:http/http.dart' as http;

class MidtransRemoteDatasource {
  String generateBasicAuthHeader(String serverKey) {
    final base64Credentials = base64Encode(utf8.encode('$serverKey:'));
    final authHeader = 'Basic $base64Credentials';

    return authHeader;
  }

  Future<QrisResponseModel> generateQRCode(
    String orderId,
    int grossAmount,
  ) async {
    final serverKey = await AuthLocalDatasource().getMitransServerKey();

    print('=== MIDTRANS DEBUG ===');
    print('Server Key RAW      : "$serverKey"');
    print('Server Key LENGTH   : ${serverKey?.length}');
    print('Authorization Header: ${generateBasicAuthHeader(serverKey)}');
    print('=====================');

    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': generateBasicAuthHeader(serverKey),
    };

    final body = jsonEncode({
      'payment_type': 'gopay',
      'transaction_details': {'gross_amount': grossAmount, 'order_id': orderId},
    });

    final response = await http.post(
      Uri.parse('https://api.sandbox.midtrans.com/v2/charge'),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = jsonDecode(response.body);

      final actions = decoded['actions'] as List;

      String? qrisImageUrl;
      String? gopaySimulatorUrl;

      for (final action in actions) {
        if (action['name'] == 'generate-qr-code-v2') {
          qrisImageUrl = action['url'];
        }

        if (action['name'] == 'deeplink-redirect') {
          gopaySimulatorUrl = action['url'];
        }
      }

      print('QRIS IMAGE URL  : $qrisImageUrl');
      print('GOPAY SIMULATOR : $gopaySimulatorUrl');

      return QrisResponseModel.fromJson(response.body);
    } else {
      throw Exception('Failed to generate QR Code');
    }
  }

  Future<QrisStatusResponseModel> checkPaymentStatus(String orderId) async {
    final serverKey = await AuthLocalDatasource().getMitransServerKey();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': generateBasicAuthHeader(serverKey),
    };

    final response = await http.get(
      Uri.parse('https://api.sandbox.midtrans.com/v2/$orderId/status'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return QrisStatusResponseModel.fromJson(response.body);
    } else {
      throw Exception('Failed to check payment status');
    }
  }
}
