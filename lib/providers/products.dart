import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'product.dart';
import '../models/http_exception.dart';

class Products with ChangeNotifier {

  static const serverUrl = 'https://flutter-shop-app-backend.firebaseio.com/';
  final String authToken;
  final String userId;

  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //   'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //   'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //   'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //   'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Product findById(String productId) {
    return _items.firstWhere((item) => item.id == productId);
  }

  Future<void> addProduct(Product product) {
    final url = serverUrl + 'products.json?auth=$authToken';

    return http.post(
      url,
      body: json.encode({
          'title': product.title,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'description': product.description,
          'creatorId': userId,
      }),
    ).then((response) {

        if (response.statusCode == 200) {
          final Product newProduct = Product(
            id: json.decode(response.body)['name'],
            title: product.title,
            price: product.price,
            imageUrl: product.imageUrl,
            description: product.description,
          );
          _items.add(newProduct);
          notifyListeners();
        }

    }).catchError((error) {
        throw error;
    });

  }

  Future<void> updateProduct(String id, Product editedProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);

    if (prodIndex >= 0) {
      final url = serverUrl + 'products/$id.json?auth=$authToken';
      http.patch(
        url,
        body: json.encode({
            'title': editedProduct.title,
            'description': editedProduct.description,
            'price': editedProduct.price,
            'imageUrl': editedProduct.imageUrl,
        }),
      );

      _items[prodIndex] = editedProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {

    final url = serverUrl + 'products/$id.json?auth=$authToken';
    final response = await http.delete(url);
    if (response.statusCode == 200) {
      _items.removeWhere((prod) => prod.id == id);
      notifyListeners();
    } else {
      throw HttpException('Could not delete product');
    }

  }

  Future<void> fetchProducts([bool filterByUser = false]) async {

    final filter = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    String url = serverUrl + 'products.json?auth=$authToken&$filter';

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }

      url = serverUrl + '/userFavorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);

      final List<Product> loadedProducts = [];
      extractedData.forEach((id, item) {
          loadedProducts.add(Product(
              id: id,
              title: item['title'],
              description: item['description'],
              price: item['price'],
              imageUrl: item['imageUrl'],
              isFavorite: favoriteData == null ? false : favoriteData[id] ?? false,
          ));
      });

      _items = loadedProducts;
      notifyListeners();

    } catch(error) {
      throw (error);
    }

  }

}
