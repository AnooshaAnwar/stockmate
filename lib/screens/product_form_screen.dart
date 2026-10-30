import 'package:flutter/material.dart';

import '../models/product.dart';
import '../utils/validators.dart';

/// Form used for both adding and editing a product.
/// - If [product] is null, it is "Add" mode.
/// - If [product] is given, it is "Edit" mode and fields are pre-filled.
/// On Save it returns the finished Product via Navigator.pop.
class ProductFormScreen extends StatefulWidget {
  final Product? product;

  const ProductFormScreen({super.key, this.product});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _quantityController;
  late final TextEditingController _categoryController;

  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameController = TextEditingController(text: p?.name ?? '');
    _priceController = TextEditingController(
      text: p == null ? '' : _formatPrice(p.price),
    );
    _quantityController = TextEditingController(
      text: p == null ? '' : p.quantity.toString(),
    );
    _categoryController = TextEditingController(text: p?.category ?? '');
  }

  /// Shows 1850.0 as "1850" but keeps 99.5 as "99.5".
  String _formatPrice(double price) {
    return price == price.truncateToDouble()
        ? price.toInt().toString()
        : price.toString();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _save() {
    // Runs every validator. If any field is invalid, errors show and we stop.
    if (!_formKey.currentState!.validate()) return;

    final product = Product(
      // Keep the same id when editing; create a new one when adding.
      id: widget.product?.id ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      price: double.parse(_priceController.text.trim()),
      quantity: int.parse(_quantityController.text.trim()),
      category: _categoryController.text.trim(),
    );

    Navigator.pop(context, product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Product' : 'Add Product'),
      ),
      // SingleChildScrollView keeps the form usable on small screens
      // and when the keyboard is open.
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Product name *',
                  prefixIcon: Icon(Icons.label_outline),
                ),
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                validator: validateName,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price (Rs) *',
                  prefixIcon: Icon(Icons.payments_outlined),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.next,
                validator: validatePrice,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantity *',
                  prefixIcon: Icon(Icons.numbers),
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                validator: validateQuantity,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category (optional)',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                textInputAction: TextInputAction.done,
                textCapitalization: TextCapitalization.words,
                validator: validateCategory,
                onFieldSubmitted: (_) => _save(),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: Text(_isEditing ? 'Save Changes' : 'Add Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}