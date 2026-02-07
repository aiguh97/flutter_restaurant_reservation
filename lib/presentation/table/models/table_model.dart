enum TableStatus { available, occupied }

class TableModel {
  final int id;
  final String name;
  final int capacity;
  final String type;

  /// kalau nanti mau floor plan → masih aman
  final double positionX;
  final double positionY;

  /// status meja
  final TableStatus status;

  TableModel({
    required this.id,
    required this.name,
    required this.capacity,
    required this.type,
    this.positionX = 0,
    this.positionY = 0,
    this.status = TableStatus.available,
  });

  bool get isOccupied => status == TableStatus.occupied;
  bool get isAvailable => status == TableStatus.available;

  /// ✅ FACTORY AMAN (API kebal typo & null)
  factory TableModel.fromMap(Map<String, dynamic> map) {
    final bool occupied =
        _parseBool(map['is_occupied']) ||
        _parseInt(map['status']) == 1 ||
        map['status'] == 'occupied';

    return TableModel(
      id: _parseInt(map['id']),
      name: map['name']?.toString() ?? '',
      capacity: _parseInt(map['capacity']),
      type: map['type']?.toString() ?? '',
      positionX: _parseDouble(map['position_x']),
      positionY: _parseDouble(map['position_y']),
      status: occupied ? TableStatus.occupied : TableStatus.available,
    );
  }

  // ================== SAFE PARSER ==================

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  static bool _parseBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      return value.toLowerCase() == 'true' ||
          value.toLowerCase() == 'yes' ||
          value == '1';
    }
    return false;
  }
}
