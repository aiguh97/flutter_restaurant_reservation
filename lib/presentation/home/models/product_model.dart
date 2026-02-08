import 'package:restoguh/core/extensions/int_ext.dart';
import 'package:restoguh/presentation/setting/models/category_model.dart';

class ProductModel {
  final String image;
  final String name;
  final Category category;
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
    final categoryData = map['category'];

    // Jika API mengirim category sebagai Map
    Category category;
    if (categoryData is Map<String, dynamic>) {
      category = Category.fromJson(categoryData);
    }
    // Jika API hanya mengirim String (nama category)
    else if (categoryData is String) {
      category = Category(id: 0, name: categoryData);
    }
    // Fallback
    else {
      category = Category(id: 0, name: '');
    }

    return ProductModel(
      image: map['image']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      category: category,
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
