import 'package:flutter/material.dart';

class SudokuCase extends StatelessWidget {
  final int value;
  final bool isSelected;
  final VoidCallback onTap;
  final int? expectedValue;

  const SudokuCase({
    Key? key,
    required this.value,
    required this.isSelected,
    required this.onTap,
    this.expectedValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color textColor = expectedValue != null && value == 0
        ? const Color(0xa093bbea)
        : Colors.black;
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 0.3),
          color: isSelected ? Colors.blueAccent.shade100.withAlpha(100) : Colors.transparent,
        ),
        child: Center(
          child: Text(
            value != 0 ? value.toString() : (expectedValue != null ? expectedValue.toString() : ''),
            style: TextStyle(
              fontSize: 16,
              fontWeight: expectedValue != null && value == 0 ? FontWeight.w400 : FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
