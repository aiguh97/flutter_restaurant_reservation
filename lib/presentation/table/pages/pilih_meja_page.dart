import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:restoguh/core/components/buttons.dart';
import 'package:restoguh/core/components/spaces.dart';

import 'package:restoguh/data/datasources/table_remote_datasource.dart';
import 'package:restoguh/presentation/table/bloc/table_bloc.dart';
import 'package:restoguh/presentation/table/bloc/table_event.dart';
import 'package:restoguh/presentation/table/bloc/table_state.dart';
import 'package:restoguh/presentation/table/cubit/selected_table_cubit.dart';
import 'package:restoguh/presentation/table/models/table_model.dart';
import 'package:restoguh/presentation/table/pages/table_item.dart';
import 'package:restoguh/presentation/table/pages/main_table_item.dart';

class PilihMejaPage extends StatelessWidget {
  const PilihMejaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Pastikan FetchTables dipanggil
      create: (context) {
        final cubitSelected = context.read<SelectedTableCubit>().state;

        return TableBloc(TableRemoteDatasource())
          ..add(FetchTables(initialSelected: cubitSelected));
      },

      child: Scaffold(
        appBar: AppBar(title: const Text('Pilih Meja'), centerTitle: true),
        body: SafeArea(
          child: BlocBuilder<TableBloc, TableState>(
            builder: (context, state) {
              if (state is TableLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is TableError) {
                return Center(child: Text('Error: ${state.message}'));
              }

              if (state is TableLoaded) {
                final tables = state.tables;

                // Map ID ke Model
                final Map<int, TableModel> tableMap = {
                  for (var t in tables) t.id: t,
                };

                // Konfigurasi Layout (Index Grid -> ID Meja)
                final Map<int, int?> layoutConfig = {
                  0: 2,
                  1: 3,
                  2: 4,
                  3: 5,
                  4: null,
                  5: 6,
                  6: 7,
                  7: 1,
                  8: 8,
                  9: 9,
                  10: null,
                  11: 10,
                  12: 11,
                  13: 12,
                  14: 13,
                };

                return Column(
                  children: [
                    const SpaceHeight(16),

                    // ... (UI Time Slot tetap sama)
                    const Text(
                      'Select Table',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SpaceHeight(16),

                    // LEGEND (PENTING AGAR TIDAK BINGUNG)
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _LegendItem(color: Colors.white, label: 'Avail'),
                        SizedBox(width: 10),
                        _LegendItem(color: Colors.orange, label: 'Reserved'),
                        SizedBox(width: 10),
                        _LegendItem(color: Colors.red, label: 'Occupied'),
                      ],
                    ),

                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(20),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                              childAspectRatio: 1,
                            ),
                        itemCount: 15,
                        itemBuilder: (context, index) {
                          final targetId = layoutConfig[index];
                          if (targetId == null) return const SizedBox();

                          final table = tableMap[targetId];
                          // JIKA TABLE TIDAK ADA DI DATABASE, JANGAN BLANK
                          if (table == null) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.help_outline,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          }

                          return GestureDetector(
                            onTap: (table.isOccupied || table.isReserved)
                                ? () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Meja ini sudah dipesan/terisi',
                                        ),
                                      ),
                                    );
                                  }
                                : () => context.read<TableBloc>().add(
                                    SelectTable(table),
                                  ),
                            child: table.id == 1
                                ? MainTableItem(
                                    table: table,
                                    isSelected:
                                        state.selectedTable?.id == table.id,
                                  )
                                : TableItem(
                                    table: table,
                                    isSelected:
                                        state.selectedTable?.id == table.id,
                                  ),
                          );
                        },
                      ),
                    ),

                    // CONFIRM BUTTON
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Button.filled(
                        label: 'Confirm Table',
                        disabled: state.selectedTable == null,
                        onPressed: () {
                          final selected = state.selectedTable!;

                          // simpan ke cubit global
                          context.read<SelectedTableCubit>().selectTable(
                            selected,
                          );

                          // kembali ke home
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                );
              }

              return const Center(child: Text("No Data"));
            },
          ),
        ),
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  final String label;

  const _TimeChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: color, width: 1.5),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
