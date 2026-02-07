import 'dart:convert';

import 'package:flutter_pos_2/presentation/setting/models/category_model.dart';

class CategoryResponseModel {
  final bool status;
  final String message;
  final List<CategoryResponse> data;

  CategoryResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CategoryResponseModel.fromJson(String str) =>
      CategoryResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CategoryResponseModel.fromMap(Map<String, dynamic> json) =>
      CategoryResponseModel(
        status: _parseBool(json["status"]),
        message: json["message"]?.toString() ?? '',
        data: List<CategoryResponse>.from(
          json["data"].map((x) => CategoryResponse.fromMap(x)),
        ),
      );

  /// Helper function untuk convert dynamic ke bool
  static bool _parseBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is String) {
      return value.toLowerCase() == 'true';
    }
    if (value is int) {
      return value != 0;
    }
    return false;
  }

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toMap())),
  };
}

class CategoryResponse {
  final int id;
  final String name;
  final String? description;
  final String? image;

  CategoryResponse({
    required this.id,
    required this.name,
    this.description,
    this.image,
  });

  factory CategoryResponse.fromMap(Map<String, dynamic> json) =>
      CategoryResponse(
        id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
        name: json['name']?.toString() ?? '',
        description: json['description']?.toString(),
        image: json['image']?.toString(),
      );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "description": description,
    "image": image,
  };

  /// Convert ke Bloc Category model
  Category toCategoryBloc() {
    return Category(id: id, name: name, description: description, image: image);
  }
}
