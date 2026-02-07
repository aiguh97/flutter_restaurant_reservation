import 'package:flutter_pos_2/data/models/response/reservation_response_model.dart';
// import 'package:flutter_pos_app/data/models/response/reservation_response_model.dart';

abstract class ReservationState {}

class ReservationInitial extends ReservationState {}

class ReservationLoading extends ReservationState {}

class ReservationSuccess extends ReservationState {
  final ReservationData data;

  ReservationSuccess(this.data);
}

class ReservationError extends ReservationState {
  final String message;

  ReservationError(this.message);
}
