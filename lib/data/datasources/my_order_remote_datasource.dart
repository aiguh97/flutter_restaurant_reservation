// my_order_remote_datasource.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restoguh/data/datasources/auth_local_datasource.dart';
import 'package:restoguh/presentation/my-order/models/order_response_model.dart';
import '../../../core/constants/variables.dart';
// import '../../auth/data/datasources/auth_local_datasource.dart';
// import '../models/order_response_model.dart';

class MyOrderRemoteDatasource {
  Future<List<Order>> getMyOrders() async {
    final authData = await AuthLocalDatasource().getAuthData();
    final token = authData?.token;

    final response = await http.get(
      Uri.parse('${Variables.baseUrl}/api/my-orders'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = OrderResponseModel.fromJson(jsonDecode(response.body));
      return data.data;
    } else {
      throw Exception('Gagal memuat pesanan');
    }
  }
}
