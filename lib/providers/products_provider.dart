import 'package:eCommerce/screens/admin/admin_home_screen.dart';
import 'package:flutter/material.dart';
import './product_provider.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

  var _showFavoritesOnly = false;
  var _isSearch = false;
  String _searchString;

  List<Product> get items {
    if (_isSearch) {
      return _items
          .where((prod) =>
              prod.title.toLowerCase().compareTo(_searchString) >= 0 ||
              prod.shortInfo.toLowerCase().compareTo(_searchString) >= 0)
          .toList();
    } else if (_showFavoritesOnly) {
      return _items.where((prod) => prod.isFavorite).toList();
    }
    return [..._items];
  }

  void searchResult(String searchText) {
    _isSearch = true;
    _searchString = searchText;
    notifyListeners();
  }

  void showFavoritesOnly() {
    _showFavoritesOnly = true;
    notifyListeners();
  }

  void showAll() {
    _showFavoritesOnly = false;
    notifyListeners();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProducts(userId) async {
    try {
      final docsCollection = await productsRef.get();
      final List<Product> loadedProducts = [];
      docsCollection.docs.forEach((prod) {
        loadedProducts.add(
          Product(
            id: prod['id'],
            title: prod['title'],
            shortInfo: prod['shortInfo'],
            description: prod['description'],
            price: double.parse(prod['price']),
            status: prod['status'],
            isFavorite: prod['favorites'][userId] ?? false,
            imageUrl: prod['imageUrl'],
          ),
        );
      });

      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct({
    String productId,
    String adminId,
    String mediaUrl,
    String title,
    String price,
    String info,
    String description,
  }) {
    return productsRef.doc(productId).set({
      'id': productId,
      'adminId': adminId,
      'title': title,
      'shortInfo': info,
      'description': description,
      'price': price,
      'status': 'Available',
      'imageUrl': mediaUrl,
      'publishedDate': DateTime.now(),
      'favorites': {},
    }).then((_) {
      final newProduct = Product(
        id: productId,
        title: title,
        shortInfo: info,
        description: description,
        price: double.parse(price),
        status: 'Available',
        imageUrl: mediaUrl,
      );

      _items.add(newProduct);

      notifyListeners();
    }).catchError((error) {
      throw error;
    });
  }

  void deleteProduct(String id) {
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    productsRef.doc(id).get().then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    }).catchError((error) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw error;
    }).then((_) {
      existingProduct = null;
    });
  }

  Future<void> editProduct(productId, newStatus, newPrice) async {
    await productsRef.doc(productId).update({
      'status': newStatus,
      'price': newPrice,
    });
  }
}
