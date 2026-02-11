import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restoguh/presentation/kitchen/models/kitchen_order_model.dart';
import '../../core/constants/variables.dart';
import '../../data/datasources/auth_local_datasource.dart';

class KitchenRemoteDatasource {
  // Di KitchenRemoteDatasource.dart
  Future<List<KitchenOrder>> getOrders({String? status}) async {
    final authData = await AuthLocalDatasource().getAuthData();
    final token = authData?.token;

    final uri = status == null
        ? Uri.parse('${Variables.baseUrl}/api/kitchen/orders')
        : Uri.parse('${Variables.baseUrl}/api/kitchen/orders?status=$status');

    final res = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode == 200) {
      final jsonBody = jsonDecode(res.body);
      final List<dynamic> data = jsonBody['data'] ?? [];
      return data.map((e) => KitchenOrder.fromJson(e)).toList();
    }

    return [];
  }

  Future<void> updateStatus(int orderId, String status) async {
    final authData = await AuthLocalDatasource().getAuthData();
    final token = authData?.token;

    try {
      final res = await http.patch(
        Uri.parse('${Variables.baseUrl}/api/orders/$orderId/status'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'status': status}),
      );
      print('Update Status Code: ${res.statusCode}');
    } catch (e) {
      print('Error updateStatus: $e');
    }
  }
}
