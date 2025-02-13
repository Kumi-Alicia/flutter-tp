import 'package:flutter/material.dart';
import 'sudokuCase.dart';

class InnerGrid extends StatelessWidget {
  final List<int> blockValues;
  final int? selectedIndex;
  final Function(int) onCellTap;
  final List<List<int>> solvedBoard;

  const InnerGrid({
    Key? key,
    required this.blockValues,
    required this.selectedIndex,
    required this.onCellTap,
    required this.solvedBoard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(9, (index) {
        int x = index % 3;
        int y = index ~/ 3;
        int expectedValue = solvedBoard[y][x];

        return SudokuCase(
          value: blockValues[index],
          isSelected: selectedIndex == index,
          onTap: () => onCellTap(index),
          expectedValue: expectedValue == 0 ? null : expectedValue,
        );
      }),
    );
  }
}
