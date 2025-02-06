import 'package:flutter/material.dart';

class InnerGrid extends StatelessWidget {
  const InnerGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(9, (index) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0.3),
          ),
          child: const Center(
            child: Text(
              'T',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        );
      }),
    );
  }
}