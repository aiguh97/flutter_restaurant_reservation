import '../models/response/reservation_response_model.dart';

class ReservationLocalDatasource {
  ReservationLocalDatasource._();
  static final instance = ReservationLocalDatasource._();

  final List<ReservationData> _reservations = [];

  Future<void> saveReservation(ReservationData data) async {
    _reservations.add(data);
  }

  List<ReservationData> getReservations() {
    return _reservations;
  }
}
