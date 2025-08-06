import 'package:flutter/material.dart';

class SearchResultsScreen extends StatelessWidget {
  final String searchQuery;

  const SearchResultsScreen({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results for "$searchQuery"'),
      ),
      body: const Center(
        child: Text('Search results will be displayed here.'),
      ),
    );
  }
}
