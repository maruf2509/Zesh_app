import 'package:zesh_app/pages/product_detail_screen.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';

class SearchResultsScreen extends StatefulWidget {
  final String searchQuery;

  const SearchResultsScreen({super.key, required this.searchQuery});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  String? selectedCategory;
  RangeValues priceRange = const RangeValues(0, 2000);

  String? tempCategory;
  RangeValues tempPriceRange = const RangeValues(0, 2000);

  @override
  void initState() {
    super.initState();
    tempCategory = 'All';
    selectedCategory = 'All';
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = demoProducts.where((product) {
      final matchCategory =
          selectedCategory == 'All' || product.category == selectedCategory;
      final matchPrice = product.prices.values.any(
        (price) => price >= priceRange.start && price <= priceRange.end,
      );

      if (selectedCategory != null && selectedCategory != 'All') {
        return matchCategory && matchPrice;
      } else {
        final matchSearch = product.name.toLowerCase().contains(
          widget.searchQuery.toLowerCase(),
        );
        return matchSearch && matchPrice;
      }
    }).toList();

    final categories = demoProducts.map((p) => p.category).toSet().toList();
    categories.insert(0, 'All');

    return Scaffold(
      appBar: AppBar(title: Text('Search: "${widget.searchQuery}"')),
      body: Column(
        children: [
          // Filter section
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButton<String>(
                  value: tempCategory,
                  isExpanded: true,
                  items: categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      tempCategory = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                Text(
                  'Price Range: ৳${tempPriceRange.start.round()} - ৳${tempPriceRange.end.round()}',
                ),
                RangeSlider(
                  values: tempPriceRange,
                  min: 0,
                  max: 2000,
                  divisions: 20,
                  labels: RangeLabels(
                    '৳${tempPriceRange.start.round()}',
                    '৳${tempPriceRange.end.round()}',
                  ),
                  onChanged: (values) {
                    setState(() {
                      tempPriceRange = values;
                    });
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          selectedCategory = tempCategory;
                          priceRange = tempPriceRange;
                        });
                      },
                      icon: const Icon(Icons.filter_alt),
                      label: const Text("Apply Filter"),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          tempCategory = 'All';
                          selectedCategory = 'All';
                          tempPriceRange = const RangeValues(0, 2000);
                          priceRange = const RangeValues(0, 2000);
                        });
                      },
                      child: const Text("Reset Filter"),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: filteredProducts.isEmpty
                ? const Center(child: Text('No matching products found.'))
                : ListView.builder(
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailScreen(product: product),
                            ),
                          );
                        },
                        leading: Image.asset(
                          product.image,
                          width: 50,
                          height: 50,
                        ),
                        title: Text(product.name),
                        subtitle: Text(product.description),
                        trailing: Text(
                          '৳${product.prices[product.sizes.first]}',
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
