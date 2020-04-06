import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'products.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
      @required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavorite = false
  });

  void toggleFavorite(){
    final url = Products.serverUrl + 'products/$id.json';

    http.patch(
      url,
      body: json.encode({
          'isFavorite': isFavorite
      }),
    )

    .then((response) {
        if (response.statusCode == 200) {
          isFavorite = !isFavorite;
          notifyListeners();
        }
    })

    .catchError((error) {
        print(error.toString());
    });

  }
}
