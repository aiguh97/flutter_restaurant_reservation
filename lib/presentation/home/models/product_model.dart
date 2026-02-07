import 'package:flutter_pos_2/core/extensions/int_ext.dart';
import 'package:flutter_pos_2/presentation/setting/models/category_model.dart';

class ProductModel {
  final String image;
  final String name;
  final CategoryModel category;
  final int price;
  final int stock;

  ProductModel({
    required this.image,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
  });

  /// ✅ FACTORY AMAN
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    final categoryValue = map['category']?.toString() ?? '';

    return ProductModel(
      image: map['image']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      category: CategoryModel(
        value: categoryValue,
        name: categoryValue.toUpperCase(), // atau mapping manual
      ),
      price: _parseInt(map['price']),
      stock: _parseInt(map['stock']),
    );
  }

  String get priceFormat => price.currencyFormatRp;

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
