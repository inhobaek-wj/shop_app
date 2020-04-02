import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../store/cart.dart' show Cart;
import '../widgets/cart_item.dart';

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

            child: Padding(
              padding: const EdgeInsets.all(8.0),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),

                  Spacer(),

                  Consumer<Cart>(
                    builder: (BuildContext context, Cart cart, Widget child) => Chip(
                      label: Text(
                        '\$${cart.totalAmount}',
                        style: TextStyle(
                          color: Theme.of(context).primaryTextTheme.headline6.color
                        ),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 10),

          Consumer<Cart>(
            builder: (BuildContext context, Cart cart, Widget child) => Expanded(
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) => CartItem(
                  cart.items.values.toList()[index].id,
                  cart.items.values.toList()[index].title,
                  cart.items.values.toList()[index].price,
                  cart.items.values.toList()[index].quantity,
                ),
                itemCount: cart.items.length,
              ),
            ),
          ),

        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {  },
        child: Text('Order'),
        backgroundColor: Theme.of(context).primaryColor,
      ),

    );
  }

}
