import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import 'auth_local_datasource.dart';
import '../../core/constants/variables.dart';
import '../../presentation/table/models/table_model.dart';

class TableRemoteDatasource {
  Future<Either<String, List<TableModel>>> getTables() async {
    try {
      final authData = await AuthLocalDatasource().getAuthData();

      if (authData == null || authData.token == null) {
        return left('Sesi login berakhir');
      }

      // Endpoint polos tanpa query parameter
      final uri = Uri.parse('${Variables.baseUrl}/api/tables');

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer ${authData.token}',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Karena response API adalah [...], maka kita decode langsung ke List
        final List<dynamic> jsonList = json.decode(response.body);

        final tables = jsonList
            .map<TableModel>(
              (e) => TableModel.fromMap(e as Map<String, dynamic>),
            )
            .toList();

        return right(tables);
      } else {
        final errorBody = json.decode(response.body);
        return left(errorBody['message'] ?? 'Gagal mengambil data meja');
      }
    } catch (e) {
      return left('Terjadi kesalahan: $e');
    }
  }
}
