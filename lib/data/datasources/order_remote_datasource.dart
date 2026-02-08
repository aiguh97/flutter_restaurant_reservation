import 'package:restoguh/core/constants/variables.dart';
import 'package:restoguh/data/models/request/order_request_model.dart';
import 'package:http/http.dart' as http;

import 'auth_local_datasource.dart';

class OrderRemoteDatasource {
  Future<bool> sendOrder(OrderRequestModel requestModel) async {
    final url = Uri.parse('${Variables.baseUrl}/api/orders');
    final authData = await AuthLocalDatasource().getAuthData();

    // 1. Pengecekan null yang aman
    // Karena return type adalah Future<bool>, kita harus mengembalikan false, bukan 'left'
    if (authData == null || authData.token == null) {
      return false;
    }

    final Map<String, String> headers = {
      // 2. Gunakan bang operator (!) karena sudah dicek tidak null di atas
      'Authorization': 'Bearer ${authData.token!}',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    try {
      print(requestModel.toJson());
      final response = await http.post(
        url,
        headers: headers,
        body: requestModel.toJson(),
      );

      // Laravel biasanya mengembalikan 200 atau 201 untuk sukses
      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else {
        print('Order Error: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Connection Error: $e');
      return false;
    }
  }
}
