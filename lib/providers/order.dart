import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'cart.dart';
import 'products.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
      @required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime
  });
}

class Orders with ChangeNotifier {

  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {

    final url = Products.serverUrl + 'orders';
    final now = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
          'amount': total,
          'dateTime': now.toIso8601String(),
          'products': cartProducts.map(
            (cp) => {
              'id': cp.id,
              'title': cp.title,
              'price': cp.price,
              'quantity': cp.quantity,
            }
          ).toList(),
      }),
    );

    if (response.statusCode == 200) {
      _orders.insert(0, OrderItem(
          id: DateTime.now().toString(),
          amount: total,
          dateTime: DateTime.now(),
          products: cartProducts
      ));
      notifyListeners();
    } else {
      throw Exception('error is occured');
    }

  }

  Future<void> fetchOrders() async {
    const url = Products.serverUrl + 'orders.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null){
        return;
      }

      final List<OrderItem> loadedOrders = [];
      extractedData.forEach((id, item) {
          loadedOrders.add(OrderItem(
              id: id,
              amount: item['amount'],
              dateTime: DateTime.parse(item['dateTime']),
              products: (item['products'] as List<dynamic>).map((o) => CartItem(
                  id: o['id'],
                  price: o['price'],
                  title: o['title'],
                  quantity: o['quantity'],
              )).toList(),
          ));
      });

      _orders = loadedOrders.reversed.toList();
      notifyListeners();

    } catch(error) {
      print('error occured...');
      // throw (error);
    }
  }

}
