import 'package:flutter/material.dart';

class ProductChip extends StatelessWidget {
  final String label;

  const ProductChip({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.grey[600],
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
    );
  }
}
