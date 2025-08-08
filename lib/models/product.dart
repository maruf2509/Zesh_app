class Product {
  final String image;
  final String name;
  final String description;
  final double price;
  final String category;
  final List<String> sizes;

  Product({
    required this.image,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.sizes,
  });
}

List<Product> demoProducts = [
  Product(
    image: 'images/chanel.png',
    name: 'Bleu de Chanel',
    description: 'Elegant, deep and refined - embodies timeless confidence',
    price: 1200.0,
    category: 'Chanel', // <-- category added
    sizes: ['3.5ml', '6ml', '10ml', '30ml', '50ml', '100ml'],
  ),
  Product(
    image: 'images/sauvage.png',
    name: 'Dior Sauvage',
    description: 'Fresh, fierce and magnetic - captures raw masculinity',
    price: 1000.0,
    category: 'Dior',
    sizes: ['3.5ml', '6ml', '10ml', '30ml', '50ml', '100ml'],
  ),
  Product(
    image: 'images/chanel.png',
    name: 'Chanel No. 5',
    description: 'A classic floral aldehyde fragrance for women',
    price: 1200.0,
    category: 'Chanel',
    sizes: ['3.5ml', '6ml', '10ml', '30ml', '50ml', '100ml'],
  ),
  Product(
    image: 'images/sauvage.png',
    name: 'Aventus Creed',
    description: 'A fresh, woody, and amber fragrance for men',
    price: 1000.0,
    category: 'Creed',
    sizes: ['3.5ml', '6ml', '10ml', '30ml', '50ml', '100ml'],
  ),
];
