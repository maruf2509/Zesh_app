import 'package:flutter/material.dart';
import '../models/product.dart';

class SearchResultsScreen extends StatelessWidget {
  final String searchQuery;

  const SearchResultsScreen({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    // Filter the products based on the search query
    final filteredProducts = demoProducts.where((product) =>
        product.name.toLowerCase().contains(searchQuery.toLowerCase())).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results for "$searchQuery"'),
      ),
      body: filteredProducts.isEmpty
          ? const Center(child: Text('No matching products found.'))
          : ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return ListTile(
                  leading: Image.asset(product.image, width: 50, height: 50),
                  title: Text(product.name),
                  subtitle: Text(product.description),
                  trailing: Text('৳${product.price.toString()}'),
                );
              },
            ),
    );
  }
}
