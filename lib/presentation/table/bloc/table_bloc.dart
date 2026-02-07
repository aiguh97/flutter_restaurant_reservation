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

    final result = await datasource.getTables();

    result.fold(
      (error) => emit(TableError(error)),
      (tables) => emit(TableLoaded(tables: tables)),
    );
  }

  void _onSelectTable(SelectTable event, Emitter<TableState> emit) {
    if (state is TableLoaded) {
      final current = state as TableLoaded;
      emit(current.copyWith(selectedTable: event.table));
    }
  }
}
