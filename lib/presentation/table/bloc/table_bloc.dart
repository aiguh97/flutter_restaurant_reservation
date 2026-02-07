import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/datasources/table_remote_datasource.dart';
import 'table_event.dart';
import 'table_state.dart';

class TableBloc extends Bloc<TableEvent, TableState> {
  final TableRemoteDatasource datasource;

  TableBloc(this.datasource) : super(TableInitial()) {
    on<FetchTables>(_onFetchTables);
    on<SelectTable>(_onSelectTable);
  }

  Future<void> _onFetchTables(
    FetchTables event,
    Emitter<TableState> emit,
  ) async {
    emit(TableLoading());

    // final result = await datasource.getTables();
    // Hardcode date & time
    final result = await datasource.getTables(
      date: '2026-02-07',
      time: '18:30',
    );

    result.fold((error) => emit(TableError(error)), (tables) {
      // ✅ PRINT SEMUA TABLE UNTUK DEBUG
      for (var table in tables) {
        print(
          'Tablessss: id=${table.id}, name=${table.name}, '
          'occupied=${table.isOccupied}, reserved=${table.isReserved}, available=${table.isAvailable}',
        );
      }

      emit(TableLoaded(tables: tables));
    });
  }

  void _onSelectTable(SelectTable event, Emitter<TableState> emit) {
    if (state is TableLoaded) {
      final current = state as TableLoaded;
      emit(current.copyWith(selectedTable: event.table));
    }
  }
}
