import 'package:restoguh/presentation/table/models/table_model.dart';

abstract class TableEvent {}

class FetchTables extends TableEvent {
  final TableModel? initialSelected;

  FetchTables({this.initialSelected});
}

class SelectTable extends TableEvent {
  final TableModel table;

  SelectTable(this.table);
}
