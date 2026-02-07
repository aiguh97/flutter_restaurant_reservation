import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_pos_2/core/components/buttons.dart';
import 'package:flutter_pos_2/core/components/spaces.dart';

import 'package:flutter_pos_2/data/datasources/table_remote_datasource.dart';
import 'package:flutter_pos_2/presentation/table/bloc/table_bloc.dart';
import 'package:flutter_pos_2/presentation/table/bloc/table_event.dart';
import 'package:flutter_pos_2/presentation/table/bloc/table_state.dart';
import 'package:flutter_pos_2/presentation/table/models/table_model.dart';
import 'package:flutter_pos_2/presentation/table/pages/table_item.dart';
import 'package:flutter_pos_2/presentation/table/pages/main_table_item.dart';

class PilihMejaPage extends StatelessWidget {
  const PilihMejaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TableBloc(TableRemoteDatasource())..add(FetchTables()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Pilih Meja'), centerTitle: true),
        body: SafeArea(
          child: Column(
            children: [
              const SpaceHeight(16),

              /// TIME SLOT (UI only)
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: const [
                    _TimeChip('09:00 AM'),
                    _TimeChip('09:30 AM'),
                    _TimeChip('10:00 AM'),
                    _TimeChip('10:30 AM'),
                  ],
                ),
              ),

              const SpaceHeight(16),
              const Text(
                'Select Table',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              const SpaceHeight(8),

              /// TABLE LAYOUT
              /// TABLE LAYOUT
              Expanded(
                child: BlocBuilder<TableBloc, TableState>(
                  builder: (context, state) {
                    if (state is TableLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is TableLoaded) {
                      final tables = state.tables;

                      // 1. Masukkan semua meja ke dalam Map agar bisa dipanggil berdasarkan ID
                      final Map<int, TableModel> tableMap = {
                        for (var t in tables) t.id: t,
                      };

                      // 2. Tentukan posisi ID meja pada Grid (0-14)
                      // ID 1 adalah Main Table, diletakkan di slot 7
                      // Slot 4 dan 10 adalah null (SizedBox/Kosong)
                      final Map<int, int?> layoutConfig = {
                        0: 2, 1: 3, 2: 4,
                        3: 5, 4: null, 5: 6,
                        6: 7, 7: 1, 8: 8, // Slot 7 = ID 1 (Main)
                        9: 9, 10: null, 11: 10,
                        12: 11, 13: 12, 14: 13,
                      };

                      return Column(
                        children: [
                          // ... (Bagian Legend & Title tetap sama)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: GridView.builder(
                                padding: const EdgeInsets.all(16),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 20,
                                      mainAxisSpacing: 28,
                                      childAspectRatio: 1,
                                    ),
                                itemCount: 15,
                                itemBuilder: (context, index) {
                                  // Ambil ID meja untuk index grid ini
                                  final targetId = layoutConfig[index];

                                  // Jika index ini diset null (slot kosong), tampilkan SizedBox
                                  if (targetId == null) return const SizedBox();

                                  // Cari data meja di tableMap berdasarkan ID
                                  final table = tableMap[targetId];
                                  if (table == null) return const SizedBox();

                                  // Render Meja
                                  return GestureDetector(
                                    onTap: table.isOccupied || table.isReserved
                                        ? null
                                        : () => context.read<TableBloc>().add(
                                            SelectTable(table),
                                          ),
                                    child: table.id == 1
                                        ? MainTableItem(
                                            table: table,
                                            isSelected:
                                                state.selectedTable?.id ==
                                                table.id,
                                          )
                                        : TableItem(
                                            table: table,
                                            isSelected:
                                                state.selectedTable?.id ==
                                                table.id,
                                          ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    return const SizedBox();
                  },
                ),
              ),

              /// CONFIRM BUTTON
              Padding(
                padding: const EdgeInsets.all(16),
                child: BlocBuilder<TableBloc, TableState>(
                  builder: (context, state) {
                    final TableModel? selectedTable = state is TableLoaded
                        ? state.selectedTable
                        : null;

                    return Button.filled(
                      label: 'Confirm Table',
                      disabled: selectedTable == null,
                      onPressed: () {
                        Navigator.pop(context, selectedTable);
                      },
                    );
                  },
                ),
              ),
            ],
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
