import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product.dart';

class FavoritesProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<String> _favoriteProductIds = [];

  FavoritesProvider() {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        _fetchFavoriteIds();
      }
    });
  }

  List<String> get favoriteProductIds => _favoriteProductIds;

  bool isFavorite(Product product) {
    return _favoriteProductIds.contains(product.id);
  }

  Future<void> toggleFavorite(Product product) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final productRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(product.id);

    if (isFavorite(product)) {
      _favoriteProductIds.remove(product.id);
      await productRef.delete();
    } else {
      _favoriteProductIds.add(product.id);
      await productRef.set(product.toJson());
    }
    notifyListeners();
  }

  void _fetchFavoriteIds() {
    final user = _auth.currentUser;
    if (user == null) return;

    _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .snapshots()
        .listen((snapshot) {
      _favoriteProductIds = snapshot.docs.map((doc) => doc.id).toList();
      notifyListeners();
    });
  }

  Stream<List<Product>> get favoritesStream {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
    });
  }
}