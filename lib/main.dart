import 'package:flutter/material.dart';

import 'screens/inventory_screen.dart';

void main() {
  runApp(const StockMateApp());
}

/// Root widget: sets the app title and theme, and shows the inventory screen.
class StockMateApp extends StatelessWidget {
  const StockMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StockMate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: const InventoryScreen(),
    );
  }
}