import 'package:flutter/material.dart';

class NumberButton extends StatelessWidget {
  final int value;
  final Function(int) onPressed;

  const NumberButton({
    Key? key,
    required this.value,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
              (Set<WidgetState> states) {
            if (states.contains(MaterialState.hovered)) {
              return Colors.indigoAccent.shade200.withAlpha(180);
            }
            // Par défaut
            return Colors.blueAccent.shade100.withAlpha(150);
          },
        ),
        foregroundColor: WidgetStateProperty.all(Colors.white),
        padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 15, horizontal: 20)),
        elevation: WidgetStateProperty.all(5),
      ),
      onPressed: () => onPressed(value),
      child: Text(
        value.toString(),
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
