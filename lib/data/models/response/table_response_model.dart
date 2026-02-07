import 'dart:convert';

import 'package:flutter_pos_2/presentation/table/models/table_model.dart';

// import '../../presentation/table/models/table_model.dart';

class TableResponseModel {
  final List<TableModel> data;

  TableResponseModel({required this.data});

  factory TableResponseModel.fromJson(String str) =>
      TableResponseModel.fromMap(json.decode(str));

  factory TableResponseModel.fromMap(Map<String, dynamic> map) {
    return TableResponseModel(
      data: List<TableModel>.from(
        (map['data'] as List).map((e) => TableModel.fromMap(e)),
      ),
    );
  }
}
