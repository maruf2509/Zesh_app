import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String image;
  final String name;
  final String description;
  final Map<String, double> prices;
  final String category;

  const Product({
    required this.id,
    required this.image,
    required this.name,
    required this.description,
    required this.prices,
    required this.category,
  });

  List<String> get sizes => prices.keys.toList();

  @override
  List<Object?> get props => [id, name];

  // Serialization to a Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'name': name,
      'description': description,
      'prices': prices,
      'category': category,
    };
  }

  // Deserialization from a Map
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      image: json['image'],
      name: json['name'],
      description: json['description'],
      prices: Map<String, double>.from(json['prices']),
      category: json['category'],
    );
  }

  // Deserialization from a Firestore DocumentSnapshot
  factory Product.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      image: data['image'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      prices: Map<String, double>.from(data['prices'] ?? {}),
      category: data['category'] ?? '',
    );
  }
}

List<Product> demoProducts = [
  Product(
    id: 'prod_001',
    image: 'images/chanel.png',
    name: 'Bleu de Chanel',
    description: '''Elegant, deep and refined
- embodies timeless confidence''',
    prices: {
      '3.5ml': 180.0,
      '6ml': 250.0,
      '10ml': 350.0,
      '30ml': 600.0,
      '50ml': 800.0,
      '100ml': 1200.0,
    },
    category: 'Chanel',
  ),
  Product(
    id: 'prod_002',
    image: 'images/sauvage.png',
    name: 'Dior Sauvage',
    description: '''Fresh, fierce and magnetic
- captures raw masculinity''',
    prices: {
      '3.5ml': 1000.0,
      '6ml': 1500.0,
      '10ml': 2200.0,
      '30ml': 5500.0,
      '50ml': 7500.0,
      '100ml': 11000.0,
    },
    category: 'Dior',
  ),
  Product(
    id: 'prod_003',
    image: 'images/chanel.png',
    name: 'Chanel No. 5',
    description: '''A classic floral aldehyde
fragrance for women''',
    prices: {
      '3.5ml': 1300.0,
      '6ml': 1900.0,
      '10ml': 2600.0,
      '30ml': 6200.0,
      '50ml': 8500.0,
      '100ml': 12500.0,
    },
    category: 'Chanel',
  ),
  Product(
    id: 'prod_004',
    image: 'images/sauvage.png',
    name: 'Aventus Creed',
    description: '''A fresh, woody, and amber
fragrance for men''',
    prices: {
      '3.5ml': 1500.0,
      '6ml': 2200.0,
      '10ml': 3000.0,
      '30ml': 7000.0,
      '50ml': 9500.0,
      '100ml': 14000.0,
    },
    category: 'Creed',
  ),
];