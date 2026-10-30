/// App-wide constants for StockMate.

/// Low-stock threshold (documented as required by the Day 3 milestone).
///
/// Stock status rules:
///   quantity == 0                    -> Out of Stock (red)
///   quantity <= lowStockThreshold    -> Low Stock (orange)
///   quantity >  lowStockThreshold    -> In Stock (green)
///
/// Example: with a threshold of 5, a product with 5 or fewer units is "Low Stock".
const int lowStockThreshold = 5;

/// Key used to save the product list in local storage.
const String productsStorageKey = 'stockmate_products';