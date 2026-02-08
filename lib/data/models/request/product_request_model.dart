import 'package:image_picker/image_picker.dart';

class ProductRequestModel {
  final int? id; // tambahkan id untuk update
  final String name;
  final int price;
  final int stock;
  final String category;
  final int categoryId;
  final int isBestSeller;
  final XFile? image; // bisa null untuk update tanpa gambar baru

  ProductRequestModel({
    this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.category,
    required this.categoryId,
    required this.isBestSeller,
    this.image,
  });

  Map<String, String> toMap() {
    final map = {
      'name': name,
      'price': price.toString(),
      'stock': stock.toString(),
      'category': category,
      'category_id': categoryId.toString(),
      'is_best_seller': isBestSeller.toString(),
    };

    // jika id ada, tambahkan
    if (id != null) {
      map['id'] = id.toString();
    }

    return map;
  }
}
