import 'package:flutter/material.dart';

class DateHeader extends StatelessWidget {
  final String label;

  const DateHeader({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(36, 44, 88, 0.06),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
