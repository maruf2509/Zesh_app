class Product {
  final String image;
  final String name;
  final String description;
  final double price;

  Product({
    required this.image,
    required this.name,
    required this.description,
    required this.price,
  });
}

List<Product> demoProducts = [
  Product(
    image: 'images/chanel.png',
    name: 'Bleu de Chanel',
    description: 'Elegant, deep and refined - embodies timeless confidence',
    price: 1200.0,
  ),
  Product(
    image: 'images/sauvage.png',
    name: 'Dior Sauvage',
    description: 'Fresh, fierce and magnetic - captures raw musculinity',
    price: 1000.0,
  ),
  Product(
    image: 'images/chanel.png',
    name: 'Chanel No. 5',
    description: 'A classic floral aldehyde fragrance for women',
    price: 1200.0,
  ),
  Product(
    image: 'images/sauvage.png',
    name: 'Aventus Creed',
    description: 'A fresh, woody, and amber fragrance for men',
    price: 1000.0,
  ),
];
