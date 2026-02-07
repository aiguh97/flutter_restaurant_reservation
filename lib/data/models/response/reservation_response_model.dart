import 'dart:convert';

class ReservationResponseModel {
  final bool success;
  final ReservationData data;

  ReservationResponseModel({
    required this.success,
    required this.data,
  });

  factory ReservationResponseModel.fromJson(Map<String, dynamic> json) {
    return ReservationResponseModel(
      success: json['success'],
      data: ReservationData.fromJson(json['data']),
    );
  }
}

class ReservationData {
  final int id;
  final int tableId;
  final int orderId;
  final String date;
  final String startTime;
  final String endTime;
  final String status;

  ReservationData({
    required this.id,
    required this.tableId,
    required this.orderId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
  });

  factory ReservationData.fromJson(Map<String, dynamic> json) {
    return ReservationData(
      id: json['id'],
      tableId: json['table_id'],
      orderId: json['order_id'],
      date: json['date'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      status: json['status'],
    );
  }
}
