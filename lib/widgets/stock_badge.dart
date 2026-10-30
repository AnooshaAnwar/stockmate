import 'package:flutter/material.dart';

import '../models/product.dart';

/// A small colored chip that shows a product's stock status.
class StockBadge extends StatelessWidget {
  final StockStatus status;

  const StockBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final Color color;
    final String label;
    final IconData icon;

    switch (status) {
      case StockStatus.inStock:
        color = Colors.green.shade700;
        label = 'In Stock';
        icon = Icons.check_circle;
        break;
      case StockStatus.lowStock:
        color = Colors.orange.shade800;
        label = 'Low Stock';
        icon = Icons.warning_amber_rounded;
        break;
      case StockStatus.outOfStock:
        color = Colors.red.shade700;
        label = 'Out of Stock';
        icon = Icons.cancel;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}