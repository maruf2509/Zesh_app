import 'package:flutter/material.dart';
import '../models/product.dart';

class AllProductsScreen extends StatelessWidget {
  const AllProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Products'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.7,
        ),
        itemCount: demoProducts.length,
        itemBuilder: (context, index) {
          final product = demoProducts[index];
          return Card(
            elevation: 2,
            child: Column(
              children: [
                Expanded(
                  child: Image.asset(product.image, fit: BoxFit.cover),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('৳${product.price.toInt()}', style: const TextStyle(color: Colors.green)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
