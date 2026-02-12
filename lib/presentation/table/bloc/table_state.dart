import '../models/table_model.dart';

abstract class TableState {}

class TableInitial extends TableState {}

class TableLoading extends TableState {}

class TableLoaded extends TableState {
  final List<TableModel> tables;
  final TableModel? selectedTable;

  TableLoaded({required this.tables, this.selectedTable});

  TableLoaded copyWith({List<TableModel>? tables, TableModel? selectedTable}) {
    return TableLoaded(
      tables: tables ?? this.tables,
      selectedTable: selectedTable ?? this.selectedTable,
    );
  }
}

class TableError extends TableState {
  final String message;

  TableError(this.message);
}
