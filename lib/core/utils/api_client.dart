import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restoguh/data/datasources/auth_local_datasource.dart';

class ApiClient {
  static Future<http.Response> get(String url) async {
    final auth = await AuthLocalDatasource().getAuthData();

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${auth?.token}',
      },
    );

    await _handle401(response);

    return response;
  }

  static Future<http.Response> post(String url, dynamic body) async {
    final auth = await AuthLocalDatasource().getAuthData();

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${auth?.token}',
      },
      body: jsonEncode(body),
    );

    await _handle401(response);

    return response;
  }

  static Future<void> _handle401(http.Response response) async {
    if (response.statusCode == 401) {
      await AuthLocalDatasource().removeAuthData();
    }
  }
}
