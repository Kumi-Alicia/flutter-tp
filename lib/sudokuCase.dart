import 'package:flutter/material.dart';

class SudokuCase extends StatelessWidget {
  final int value;
  final bool isSelected;
  final VoidCallback onTap;

  const SudokuCase({
    Key? key,
    required this.value,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 0.3),
          color: isSelected ? Colors.blueAccent.shade100.withAlpha(100) : Colors.transparent,
        ),
        child: Center(
          child: Text(
            value != 0 ? value.toString() : '',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
