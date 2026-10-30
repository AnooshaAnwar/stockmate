import 'package:flutter/material.dart';

import '../models/product.dart';
import 'stock_badge.dart';

/// One row in the inventory list.
/// It does not change data itself. It reports user actions through callbacks,
/// and the parent screen decides what to do (and calls setState).
class ProductTile extends StatelessWidget {
  final Product product;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProductTile({
    super.key,
    required this.product,
    required this.onIncrease,
    required this.onDecrease,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Left side: name, category, price, badge
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (product.category.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          product.category,
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      'Rs ${product.price.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 6),
                    StockBadge(status: product.status),
                  ],
                ),
              ),

              // Right side: quantity controls and delete
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: 'Decrease quantity',
                        icon: const Icon(Icons.remove_circle_outline),
                        // Disabled at 0 so quantity can never go negative.
                        onPressed: product.quantity > 0 ? onDecrease : null,
                      ),
                      SizedBox(
                        width: 32,
                        child: Text(
                          '${product.quantity}',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      IconButton(
                        tooltip: 'Increase quantity',
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: onIncrease,
                      ),
                    ],
                  ),
                  IconButton(
                    tooltip: 'Delete product',
                    icon: const Icon(Icons.delete_outline),
                    color: Colors.red.shade700,
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}