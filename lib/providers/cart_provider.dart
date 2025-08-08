import 'package:flutter/material.dart';
import 'package:zesh_app/models/cart_item.dart';
import 'package:zesh_app/models/product.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addItem(Product product, String size, int quantity) {
    int existingIndex = _items.indexWhere(
      (item) => item.product == product && item.size == size,
    );

    if (existingIndex != -1) {
      // If item with same product and size exists, update quantity
      _items[existingIndex].quantity += quantity;
    } else {
      // Otherwise, add new item
      _items.add(CartItem(product: product, size: size, quantity: quantity));
    }
    notifyListeners();
  }

  void removeItem(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void updateItemQuantity(CartItem item, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(item);
    } else {
      item.quantity = newQuantity;
    }
    notifyListeners();
  }

  double get totalPrice {
    double total = 0.0;
    for (var item in _items) {
      total += (item.product.prices[item.size] ?? 0.0) * item.quantity;
    }
    return total;
  }

  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}