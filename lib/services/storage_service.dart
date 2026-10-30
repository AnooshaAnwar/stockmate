import 'package:shared_preferences/shared_preferences.dart';

import '../models/product.dart';
import '../utils/constants.dart';

/// Saves and loads the product list on the device using shared_preferences.
/// The whole list is stored as ONE JSON string under a single key.
class StorageService {
  /// Saves the full product list as JSON text.
  static Future<void> saveProducts(List<Product> products) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(productsStorageKey, Product.encodeList(products));
  }

  /// Loads the saved product list.
  /// Returns null if nothing has ever been saved (first launch),
  /// or if the saved data is damaged and cannot be read.
  static Future<List<Product>?> loadProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(productsStorageKey);

    if (saved == null) return null; // first launch

    try {
      return Product.decodeList(saved);
    } catch (_) {
      // Corrupted data: fall back to the first-launch behavior
      // instead of crashing the app.
      return null;
    }
  }
}