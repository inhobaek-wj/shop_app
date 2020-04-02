import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../store/cart.dart';

class CartScreen extends StatelessWidget {

  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart')
      ),

      body: Column(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(15),

            child: Row(
              children: <Widget>[
                Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),

                SizedBox(width: 10,),

                Consumer<Cart>(
                  builder: (BuildContext context, Cart cart, Widget child) => Chip(
                    label: Text('\$${cart.totalAmount}'),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
