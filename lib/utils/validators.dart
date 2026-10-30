/// Form validation functions for the add/edit product form.
/// Each returns an error message (String) if the value is invalid,
/// or null if the value is fine. This is exactly what Flutter's
/// TextFormField `validator:` expects.

/// Maximum lengths keep long text from breaking small screens.
const int maxNameLength = 50;
const int maxCategoryLength = 30;

/// Name is required, at most 50 characters.
String? validateName(String? value) {
  final text = value?.trim() ?? '';
  if (text.isEmpty) return 'Product name is required';
  if (text.length > maxNameLength) {
    return 'Name must be $maxNameLength characters or fewer';
  }
  return null;
}

/// Price is required, must be a number, and must be greater than 0.
String? validatePrice(String? value) {
  final text = value?.trim() ?? '';
  if (text.isEmpty) return 'Price is required';
  final price = double.tryParse(text);
  if (price == null) return 'Enter a valid number';
  if (price <= 0) return 'Price must be greater than 0';
  if (price > 10000000) return 'Price is too large';
  return null;
}

/// Quantity is required, must be a whole number, and cannot be negative.
String? validateQuantity(String? value) {
  final text = value?.trim() ?? '';
  if (text.isEmpty) return 'Quantity is required';
  final quantity = int.tryParse(text);
  if (quantity == null) return 'Enter a whole number';
  if (quantity < 0) return 'Quantity cannot be negative';
  if (quantity > 1000000) return 'Quantity is too large';
  return null;
}

/// Category is optional. If given, it must be at most 30 characters.
String? validateCategory(String? value) {
  final text = value?.trim() ?? '';
  if (text.length > maxCategoryLength) {
    return 'Category must be $maxCategoryLength characters or fewer';
  }
  return null;
}