import 'package:bloc/bloc.dart';

import '../../../data/datasources/reservation_local_datasource.dart';
import '../../../data/datasources/reservation_remote_datasource.dart';
import '../../../data/models/response/reservation_response_model.dart';
import 'reservation_event.dart';
import 'reservation_state.dart';

class ReservationBloc extends Bloc<ReservationEvent, ReservationState> {
  final ReservationRemoteDatasource remoteDatasource;
  final ReservationLocalDatasource localDatasource;

  ReservationBloc(this.remoteDatasource, this.localDatasource)
      : super(ReservationInitial()) {
    on<CreateReservation>((event, emit) async {
      emit(ReservationLoading());

      final result = await remoteDatasource.createReservation(
        tableId: event.tableId,
        orderId: event.orderId,
        date: event.date,
        startTime: event.startTime,
        endTime: event.endTime,
      );

      result.fold(
        (error) => emit(ReservationError(error)),
        (response) async {
          await localDatasource.saveReservation(response.data);
          emit(ReservationSuccess(response.data));
        },
      );
    });
  }
}
