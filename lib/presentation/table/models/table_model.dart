enum TableStatus { available, reserved, occupied }

class TableModel {
  final int id;
  final String name;
  final int capacity;
  final String type;

  /// Posisi untuk floor plan
  final double positionX;
  final double positionY;

  /// Status meja
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
  bool get isReserved => status == TableStatus.reserved;
  bool get isAvailable => status == TableStatus.available;

  /// ✅ Factory dari API
  factory TableModel.fromMap(Map<String, dynamic> map) {
    TableStatus tableStatus = TableStatus.available;

    final bool occupied = _parseBool(map['is_occupied']);
    final bool reserved = _parseBool(map['is_reserved']);

    if (occupied) {
      tableStatus = TableStatus.occupied;
    } else if (reserved) {
      tableStatus = TableStatus.reserved;
    } else {
      tableStatus = TableStatus.available;
    }

    return TableModel(
      id: _parseInt(map['id']),
      name: map['name']?.toString() ?? '',
      capacity: _parseInt(map['capacity']),
      type: map['type']?.toString() ?? '',
      positionX: _parseDouble(map['position_x']),
      positionY: _parseDouble(map['position_y']),
      status: tableStatus,
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
      final v = value.toLowerCase();
      return v == 'true' || v == 'yes' || v == '1';
    }
    return false;
  }
}
