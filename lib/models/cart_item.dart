import 'package:zesh_app/models/product.dart';

class CartItem {
  final Product product;
  final String size;
  int quantity;

  CartItem({
    required this.product,
    required this.size,
    required this.quantity,
  });

  // Override equality for easier comparison in the cart
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItem &&
          runtimeType == other.runtimeType &&
          product == other.product &&
          size == other.size;

  @override
  int get hashCode => product.hashCode ^ size.hashCode;
}