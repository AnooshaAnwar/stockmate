import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/storage_service.dart';
import '../widgets/product_tile.dart';
import 'product_form_screen.dart';

/// Main screen: shows the product list and owns the app's data.
/// All changes go through setState() so the list refreshes immediately.
class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  List<Product> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  /// Loads saved products. On the very first launch (nothing saved yet),
  /// starts with three sample products so the list is not empty.
  Future<void> _loadProducts() async {
    final saved = await StorageService.loadProducts();
    if (!mounted) return;
    setState(() {
      _products = saved ?? _sampleProducts();
      _isLoading = false;
    });
  }

  List<Product> _sampleProducts() => const [
        Product(
          id: 'sample-1',
          name: 'Basmati Rice 5kg',
          price: 1850,
          quantity: 12,
          category: 'Grocery',
        ),
        Product(
          id: 'sample-2',
          name: 'Cooking Oil 1L',
          price: 520,
          quantity: 3,
          category: 'Grocery',
        ),
        Product(
          id: 'sample-3',
          name: 'Green Tea Box',
          price: 340,
          quantity: 0,
          category: 'Beverages',
        ),
      ];

  /// Saves the current list to local storage.
  Future<void> _save() => StorageService.saveProducts(_products);

  /// Opens the form to add a new product, or edit an existing one.
  /// The form returns the finished Product when the user taps Save.
  Future<void> _openForm({Product? existing}) async {
    final result = await Navigator.push<Product>(
      context,
      MaterialPageRoute(
        builder: (_) => ProductFormScreen(product: existing),
      ),
    );

    if (result == null) return; // user went back without saving

    setState(() {
      if (existing == null) {
        _products = [..._products, result]; // add
      } else {
        _products = _products
            .map((p) => p.id == result.id ? result : p)
            .toList(); // replace edited product
      }
    });
    await _save();
  }

  /// Changes quantity by +1 or -1. Never allows a negative value.
  Future<void> _changeQuantity(Product product, int delta) async {
    final newQuantity = product.quantity + delta;
    if (newQuantity < 0) return;

    setState(() {
      _products = _products
          .map((p) =>
              p.id == product.id ? p.copyWith(quantity: newQuantity) : p)
          .toList();
    });
    await _save();
  }

  /// Asks for confirmation, then deletes the product.
  Future<void> _confirmDelete(Product product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete product?'),
        content: Text('"${product.name}" will be removed from your inventory.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _products = _products.where((p) => p.id != product.id).toList();
    });
    await _save();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Deleted "${product.name}"')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StockMate'),
        centerTitle: true,
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Empty inventory state (Day 4 requirement).
    if (_products.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.inventory_2_outlined,
                  size: 72, color: Colors.grey.shade500),
              const SizedBox(height: 12),
              Text(
                'No products yet',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              const Text(
                'Tap "Add Product" to add your first item.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      // Extra bottom padding so the floating button never hides the last item.
      padding: const EdgeInsets.only(top: 6, bottom: 88),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        return ProductTile(
          key: ValueKey(product.id),
          product: product,
          onIncrease: () => _changeQuantity(product, 1),
          onDecrease: () => _changeQuantity(product, -1),
          onEdit: () => _openForm(existing: product),
          onDelete: () => _confirmDelete(product),
        );
      },
    );
  }
}