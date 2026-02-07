import 'package:flutter/material.dart';
import 'package:flutter_pos_2/core/constants/colors.dart';
import '../models/table_model.dart';

class TableItem extends StatelessWidget {
  final TableModel table;
  final bool isSelected;

  const TableItem({super.key, required this.table, required this.isSelected});

  bool get isDisabled => table.isOccupied || table.isReserved;

  @override
  Widget build(BuildContext context) {
    final Color color = isSelected
        ? Theme.of(context).primaryColor
        : table.isOccupied
        ? Colors.yellow
        : table.isReserved
        ? Colors
              .red // ubah grey → merah supaya sesuai legend
        : Colors.green;

    return Opacity(
      opacity: isDisabled ? 0.6 : 1.0, // visual disabled
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// ── ──  (KURSI ATAS)
          _ChairRow(color),

          const SizedBox(height: 6),

          /// TABLE
          _TableBox(color),

          const SizedBox(height: 6),

          /// ── ──  (KURSI BAWAH)
          _ChairRow(color),
        ],
      ),
    );
  }

  Widget _TableBox(Color color) {
    return Container(
      width: 90,
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color, width: 2),
        color: color.withOpacity(isSelected ? 0.04 : 0.06),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            table.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          // TAMBAHKAN INI UNTUK DEBUG:
          Text(
            'ID: ${table.id}',
            style: TextStyle(fontSize: 9, color: color.withOpacity(0.7)),
          ),
        ],
      ),
    );
  }

  /// 🔥 KURSI HORIZONTAL (DASH "-")
  Widget _Chair(Color color) {
    return Container(
      width: 22,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  Widget _ChairRow(Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [_Chair(color), const SizedBox(width: 12), _Chair(color)],
    );
  }
}
