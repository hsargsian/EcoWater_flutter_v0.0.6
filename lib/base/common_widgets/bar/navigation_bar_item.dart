import 'package:flutter/material.dart';

class BottomNavigatorBarItem extends StatelessWidget {
  const BottomNavigatorBarItem(
      {required this.icon, required this.title, super.key});
  final Icons icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return const Expanded(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(Icons.ac_unit_outlined), Text('Hello')]));
  }
}
