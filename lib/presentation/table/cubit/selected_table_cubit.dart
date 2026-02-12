import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restoguh/presentation/table/models/table_model.dart';

class SelectedTableCubit extends Cubit<TableModel?> {
  SelectedTableCubit() : super(null);

  void selectTable(TableModel table) => emit(table);

  void clear() => emit(null);
}
