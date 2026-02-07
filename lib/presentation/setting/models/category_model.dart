class Category {
  final int id;
  final String name;
  final String? description;
  final String? image;

  Category({
    required this.id,
    required this.name,
    this.description,
    this.image,
  });

  // Dari API
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: _parseInt(json['id']),
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      image: json['image']?.toString(),
    );
  }

  // Dari local database
  factory Category.fromLocal(Map<String, dynamic> json) {
    return Category(
      id: _parseInt(json['id']),
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      image: json['image']?.toString(),
    );
  }

  // Untuk simpan ke SQLite
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'description': description, 'image': image};
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'description': description, 'image': image};
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  /// Convert ke Bloc / local Category model
  Category toCategory() {
    return Category(id: id, name: name, description: description, image: image);
  }
}
