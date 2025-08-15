import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zesh_app/pages/cart_screen.dart';
import 'package:zesh_app/pages/favorites_screen.dart';
import 'package:zesh_app/pages/notifications_screen.dart';
import 'package:zesh_app/pages/product_detail_screen.dart';
import 'package:zesh_app/providers/favorites_provider.dart';

import '../models/product.dart';
import 'profile.dart';
import 'search_results_screen.dart';
import 'all_products_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    FavoritesScreen(),
    CartScreen(),
    NotificationsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favourite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;

  // Define constants for consistent spacing and styling
  static const double kHorizontalPadding = 20.0;
  static const double kVerticalSpacing = 15.0;
  static const double kIconSize = 28.0;
  static const double kFontSizeLarge = 20.0;
  static const double kFontSizeMedium = 16.0;
  static const double kFontSizeSmall = 14.0;
  static const double kBorderRadius = 15.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            SizedBox(
              height: _HomeScreenState.kVerticalSpacing,
            ), // Initial spacing from top
            _buildHeader(context),
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
              ), // Adjusted vertical padding
              child: Image.asset(
                'images/logo.png',
                height: 80,
              ), // Logo before banner
            ),
            _buildBanner(),
            SizedBox(
              height: _HomeScreenState.kVerticalSpacing * 1.5,
            ), // More space before product section
            _buildProductSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _HomeScreenState.kHorizontalPadding,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.menu, size: _HomeScreenState.kIconSize),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          const SizedBox(width: 10), // Spacing between icon and search bar
          Expanded(
            child: TextField(
              onSubmitted: (value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SearchResultsScreen(searchQuery: value),
                  ),
                );
              },
              decoration: InputDecoration(
                hintText: 'Search Here...',
                suffixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    _HomeScreenState.kBorderRadius * 2,
                  ),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 20.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _HomeScreenState.kHorizontalPadding,
      ),
      child: Container(
        height: 370,
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('images/banner.png'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(_HomeScreenState.kBorderRadius),
        ),
      ),
    );
  }

  Widget _buildProductSection(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start, // Align content to the start
      children: [
        _buildSectionHeader(context, 'NEW PERFUME SERIES'),
        SizedBox(
          height: _HomeScreenState.kVerticalSpacing * 0.5,
        ), // Spacing between header and carousel
        Stack(
          alignment: Alignment.center,
          children: [
            _buildProductCarousel(),
            Positioned(
              left: 0,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                },
              ),
            ),
            Positioned(
              right: 0,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black54,
                ),
                onPressed: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                },
              ),
            ),
          ],
        ),
        SizedBox(
          height: _HomeScreenState.kVerticalSpacing * 1.5,
        ), // Spacing between sections
        _buildSectionHeader(context, 'MOST POPULAR'),
        SizedBox(
          height: _HomeScreenState.kVerticalSpacing * 0.5,
        ), // Spacing between header and grid
        _buildProductGrid(),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _HomeScreenState.kHorizontalPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: _HomeScreenState.kFontSizeLarge,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (title == 'NEW PERFUME SERIES')
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AllProductsScreen(),
                  ),
                );
              },
              child: const Text(
                'View All',
                style: TextStyle(fontSize: _HomeScreenState.kFontSizeMedium),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProductCarousel() {
    return SizedBox(
      height: 250, // Adjusted height for carousel
      child: ListView.builder(
        controller: _pageController, // Assign controller
        scrollDirection: Axis.horizontal,
        itemCount: demoProducts.length,
        itemBuilder: (context, index) {
          final product = demoProducts[index];
          return Padding(
            padding: EdgeInsets.only(
              left: index == 0
                  ? _HomeScreenState.kHorizontalPadding
                  : _HomeScreenState.kHorizontalPadding / 2,
              right: index == demoProducts.length - 1
                  ? _HomeScreenState.kHorizontalPadding
                  : _HomeScreenState.kHorizontalPadding / 2,
            ),
            child: _buildProductCard(product),
          );
        },
      ),
    );
  }

  Widget _buildProductGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _HomeScreenState.kHorizontalPadding,
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7, // Adjusted aspect ratio for grid items
          crossAxisSpacing:
              _HomeScreenState.kHorizontalPadding /
              2, // Spacing between grid items horizontally
          mainAxisSpacing: _HomeScreenState
              .kVerticalSpacing, // Spacing between grid items vertically
        ),
        itemCount: demoProducts.length,
        itemBuilder: (context, index) {
          final product = demoProducts[index];
          return _buildProductCard(product);
        },
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final isFavorite = favoritesProvider.isFavorite(product);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Card(
        elevation: 0, // Removed elevation
        color: Colors.transparent, // Made background transparent
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_HomeScreenState.kBorderRadius),
        ),
        margin: EdgeInsets.zero, // Remove default card margin
        child: SizedBox(
          height: 250, // Set a fixed height for the card content
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(_HomeScreenState.kBorderRadius),
                    topRight: Radius.circular(_HomeScreenState.kBorderRadius),
                  ),
                  child: Image.asset(product.image, fit: BoxFit.cover),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(
                  _HomeScreenState.kHorizontalPadding / 2,
                ), // Consistent padding inside card
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: _HomeScreenState.kFontSizeMedium,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.description,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: _HomeScreenState.kFontSizeSmall,
                      ),
                      maxLines: 1, // Limit description to one line
                      overflow:
                          TextOverflow.ellipsis, // Add ellipsis if it overflows
                    ),
                    const SizedBox(
                      height: 8,
                    ), // Increased spacing before price/favorite
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(
                              _HomeScreenState.kBorderRadius * 1.5,
                            ),
                          ),
                          child: Text(
                            '৳${product.prices[product.sizes.first]?.toInt()}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: _HomeScreenState.kFontSizeMedium,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.grey,
                            size:
                                _HomeScreenState.kIconSize *
                                0.8, // Smaller icon for product card
                          ),
                          onPressed: () {
                            favoritesProvider.toggleFavorite(product);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
