import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:restoguh/data/datasources/my_order_remote_datasource.dart';
import 'package:restoguh/presentation/my-order/models/order_response_model.dart';
// Import model Order agar List<Order> dikenali

part 'my_order_event.dart';
part 'my_order_state.dart';
part 'my_order_bloc.freezed.dart'; // File ini akan digenerate otomatis

class MyOrderBloc extends Bloc<MyOrderEvent, MyOrderState> {
  final MyOrderRemoteDatasource datasource;

  MyOrderBloc(this.datasource) : super(const _Initial()) {
    on<_Fetch>((event, emit) async {
      emit(const _Loading());
      try {
        final result = await datasource.getMyOrders();
        emit(_Loaded(result));
      } catch (e) {
        emit(_Error(e.toString()));
      }
    });
  }
}
