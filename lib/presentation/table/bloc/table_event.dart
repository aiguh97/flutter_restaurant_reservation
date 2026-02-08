import 'package:restoguh/presentation/table/models/table_model.dart';

abstract class TableEvent {}

class FetchTables extends TableEvent {}

class SelectTable extends TableEvent {
  final TableModel table;

  SelectTable(this.table);
}
