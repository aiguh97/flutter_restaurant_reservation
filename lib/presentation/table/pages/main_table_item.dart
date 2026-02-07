import 'package:flutter/material.dart';
import '../models/table_model.dart';

class MainTableItem extends StatelessWidget {
  final TableModel table;
  final bool isSelected;

  const MainTableItem({
    super.key,
    required this.table,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = isSelected
        ? const Color.fromARGB(255, 56, 0, 153)
        : table.isOccupied
        ? Colors.red
        : Colors.green;

    return Center(
      child: SizedBox(
        width: 99,
        height: 99,
        child: Stack(
          alignment: Alignment.center,
          children: [
            /// ATAS
            Positioned(top: 1, left: 20, child: _Chair(color)),
            Positioned(top: 1, right: 20, child: _Chair(color)),

            /// BAWAH
            Positioned(bottom: 1, left: 20, child: _Chair(color)),
            Positioned(bottom: 1, right: 20, child: _Chair(color)),

            /// KIRI
            Positioned(left: 1, top: 25, child: _ChairVertical(color)),
            Positioned(left: 1, bottom: 25, child: _ChairVertical(color)),

            /// KANAN
            Positioned(right: 1, top: 25, child: _ChairVertical(color)),
            Positioned(right: 1, bottom: 25, child: _ChairVertical(color)),

            /// MAIN TABLE
            _MainTableBox(color),
          ],
        ),
      ),
    );
  }

  Widget _MainTableBox(Color color) {
    return Container(
      width: 80, // ⬅️ diperkecil
      height: 80,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
        color: color.withOpacity(isSelected ? 0.18 : 0.06),
      ),
      child: Text(
        table.name,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  Widget _Chair(Color color) => Container(
    width: 18,
    height: 6,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(4),
    ),
  );

  Widget _ChairVertical(Color color) => Container(
    width: 6,
    height: 18,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(4),
    ),
  );

  Widget _ChairRow(Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Chair(color),
        const SizedBox(width: 14),
        _Chair(color),
        const SizedBox(width: 14),
        _Chair(color),
      ],
    );
  }

  /// | | | (vertical chairs kiri-kanan)
  Widget _ChairColumn(Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Chair(color),
        const SizedBox(height: 10),
        _Chair(color),
        const SizedBox(height: 10),
        _Chair(color),
      ],
    );
  }
}
