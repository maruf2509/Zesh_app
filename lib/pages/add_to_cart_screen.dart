import 'package:flutter/material.dart';
import '../models/product.dart';

class AddToCartScreen extends StatelessWidget {
  final Product product;

  const AddToCartScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(product.image, height: 200),
            Text(product.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(product.description),
            Text('৳${product.price.toInt()}', style: const TextStyle(fontSize: 20, color: Colors.green)),
            ElevatedButton(
              onPressed: () {
                // Add to cart logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${product.name} added to cart!')),
                );
              },
              child: const Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}
