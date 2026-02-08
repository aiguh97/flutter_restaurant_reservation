import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import 'auth_local_datasource.dart';
import '../../core/constants/variables.dart';
import '../../presentation/table/models/table_model.dart';

class TableRemoteDatasource {
  Future<Either<String, List<TableModel>>> getTables({
    String? date,
    String? time,
  }) async {
    try {
      final authData = await AuthLocalDatasource().getAuthData();
      // 1. Tambahkan pengecekan ini
      if (authData == null || authData.token == null) {
        return left('Sesi login berakhir');
      }

      // Build query params jika date & time dikirim
      final queryParams = <String, String>{};
      if (date != null) queryParams['date'] = date;
      if (time != null) queryParams['time'] = time;

      final uri = Uri.parse(
        '${Variables.baseUrl}/api/tables',
      ).replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer ${authData.token}',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final tables = jsonList
            .map<TableModel>(
              (e) => TableModel.fromMap(e as Map<String, dynamic>),
            )
            .toList();

        return right(tables);
      } else {
        // Bisa parsing json error message kalau backend mengirim {"message": "..."}
        final errorBody = json.decode(response.body);
        return left(errorBody['message'] ?? 'Unknown error');
      }
    } catch (e) {
      return left(e.toString());
    }
  }
}
