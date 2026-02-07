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
              Expanded(
                child: BlocBuilder<TableBloc, TableState>(
                  builder: (context, state) {
                    if (state is TableLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is TableLoaded) {
                      final tables = state.tables;

                      final TableModel? mainTable = tables
                          .where((e) => e.type == 'main')
                          .cast<TableModel?>()
                          .firstOrNull;

                      final otherTables = tables
                          .where((e) => e.type != 'main')
                          .toList();

                      return Column(
                        children: [
                          /// LEGEND
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                _LegendItem(
                                  color: Colors.green,
                                  label: 'Available',
                                ),
                                SizedBox(width: 16),
                                _LegendItem(
                                  color: Colors.red,
                                  label: 'Occupied',
                                ),
                                SizedBox(width: 16),
                                _LegendItem(
                                  color: Color(0xFF7C39ED),
                                  label: 'Selected',
                                ),
                              ],
                            ),
                          ),

                          const SpaceHeight(12),

                          /// MAIN TABLE (TENGAH)
                          if (mainTable != null) ...[
                            GestureDetector(
                              onTap: () {
                                context.read<TableBloc>().add(
                                  SelectTable(mainTable),
                                );
                              },
                              child: TableItem(
                                table: mainTable,
                                isSelected:
                                    state.selectedTable?.id == mainTable.id,
                              ),
                            ),
                            const SpaceHeight(24),
                          ],

                          /// TITLE
                          Row(
                            children: const [
                              Expanded(child: Divider()),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  '2-SEAT TABLES',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Expanded(child: Divider()),
                            ],
                          ),

                          const SpaceHeight(12),

                          /// GRID TABLES
                          Expanded(
                            child: GridView.builder(
                              padding: const EdgeInsets.all(16),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 28,
                                    childAspectRatio: 0.8,
                                  ),
                              itemCount: otherTables.length,
                              itemBuilder: (context, index) {
                                final table = otherTables[index];
                                final isSelected =
                                    state.selectedTable?.id == table.id;

                                return GestureDetector(
                                  onTap: table.isOccupied
                                      ? null
                                      : () {
                                          context.read<TableBloc>().add(
                                            SelectTable(table),
                                          );
                                        },
                                  child: TableItem(
                                    table: table,
                                    isSelected: isSelected,
                                  ),
                                );
                              },
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
