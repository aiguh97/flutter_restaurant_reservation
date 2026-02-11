import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:restoguh/data/datasources/kitchen_remote_datasource.dart';
// 1. Pastikan import ini aktif dan path-nya benar
import 'package:restoguh/presentation/kitchen/models/kitchen_order_model.dart';

part 'kitchen_event.dart';
part 'kitchen_state.dart';
part 'kitchen_bloc.freezed.dart';

class KitchenBloc extends Bloc<KitchenEvent, KitchenState> {
  final KitchenRemoteDatasource datasource;

  KitchenBloc(this.datasource) : super(const KitchenState.loading()) {
    on<_Fetch>((event, emit) async {
      emit(const KitchenState.loading());
      try {
        final List<KitchenOrder> orders = await datasource.getOrders();

        // HAPUS FILTER INI
        emit(KitchenState.loaded(orders));
      } catch (e) {
        emit(KitchenState.error(e.toString()));
      }
    });

    on<_UpdateStatus>((event, emit) async {
      try {
        await datasource.updateStatus(event.orderId, event.status);
        add(const KitchenEvent.fetch());
      } catch (e) {
        emit(KitchenState.error("Gagal update status: ${e.toString()}"));
      }
    });
  }
}
