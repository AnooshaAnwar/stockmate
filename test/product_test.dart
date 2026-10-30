import 'package:flutter_test/flutter_test.dart';
import 'package:stockmate/models/product.dart';
import 'package:stockmate/utils/constants.dart';
import 'package:stockmate/utils/validators.dart';

void main() {
  group('Product JSON', () {
    test('toJson then fromJson gives back the same product', () {
      const original = Product(
        id: 'p1',
        name: 'Rice',
        price: 99.5,
        quantity: 7,
        category: 'Grocery',
      );

      final copy = Product.fromJson(original.toJson());

      expect(copy.id, original.id);
      expect(copy.name, original.name);
      expect(copy.price, original.price);
      expect(copy.quantity, original.quantity);
      expect(copy.category, original.category);
    });

    test('encodeList and decodeList round-trip a whole list', () {
      const products = [
        Product(id: 'a', name: 'Tea', price: 100, quantity: 2),
        Product(id: 'b', name: 'Oil', price: 520, quantity: 9, category: 'Food'),
      ];

      final decoded = Product.decodeList(Product.encodeList(products));

      expect(decoded.length, 2);
      expect(decoded[0].name, 'Tea');
      expect(decoded[1].category, 'Food');
    });

    test('whole-number price saved as int still loads as double', () {
      final product = Product.fromJson({
        'id': 'x',
        'name': 'Salt',
        'price': 50, // int, not 50.0
        'quantity': 1,
      });

      expect(product.price, 50.0);
      expect(product.category, ''); // missing category defaults to empty
    });
  });

  group('Stock status', () {
    test('0 units is out of stock', () {
      const p = Product(id: '1', name: 'A', price: 1, quantity: 0);
      expect(p.status, StockStatus.outOfStock);
    });

    test('at the threshold is low stock', () {
      final p = Product(id: '1', name: 'A', price: 1, quantity: lowStockThreshold);
      expect(p.status, StockStatus.lowStock);
    });

    test('one above the threshold is in stock', () {
      final p = Product(
        id: '1',
        name: 'A',
        price: 1,
        quantity: lowStockThreshold + 1,
      );
      expect(p.status, StockStatus.inStock);
    });

    test('copyWith changes quantity without touching other fields', () {
      const p = Product(id: '1', name: 'A', price: 10, quantity: 3);
      final updated = p.copyWith(quantity: 4);

      expect(updated.quantity, 4);
      expect(updated.id, '1');
      expect(updated.name, 'A');
      expect(updated.price, 10);
    });
  });

  group('Validators', () {
    test('name: empty and too long are rejected, normal is accepted', () {
      expect(validateName(''), isNotNull);
      expect(validateName('   '), isNotNull);
      expect(validateName('a' * (maxNameLength + 1)), isNotNull);
      expect(validateName('Rice'), isNull);
    });

    test('price: empty, text, zero and negative are rejected', () {
      expect(validatePrice(''), isNotNull);
      expect(validatePrice('abc'), isNotNull);
      expect(validatePrice('0'), isNotNull);
      expect(validatePrice('-5'), isNotNull);
      expect(validatePrice('99.5'), isNull);
    });

    test('quantity: empty, decimal and negative are rejected', () {
      expect(validateQuantity(''), isNotNull);
      expect(validateQuantity('2.5'), isNotNull);
      expect(validateQuantity('-1'), isNotNull);
      expect(validateQuantity('0'), isNull);
      expect(validateQuantity('15'), isNull);
    });

    test('category: optional, but length limited', () {
      expect(validateCategory(''), isNull);
      expect(validateCategory(null), isNull);
      expect(validateCategory('Grocery'), isNull);
      expect(validateCategory('a' * (maxCategoryLength + 1)), isNotNull);
    });
  });
}