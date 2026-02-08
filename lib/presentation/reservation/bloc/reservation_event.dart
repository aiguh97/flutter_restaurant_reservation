abstract class ReservationEvent {}

class CreateReservation extends ReservationEvent {
  final int tableId;
  final int orderId;
  final String date;
  final String startTime;
  final String endTime;
  final String status;

  CreateReservation({
    required this.tableId,
    required this.orderId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
  });
}
