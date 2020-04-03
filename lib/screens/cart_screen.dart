import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../store/cart.dart' show Cart;
import '../store/order.dart';
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
                        '\$${cart.totalAmount.toStringAsFixed(2)}',
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
                  cart.items.keys.toList()[index],
                ),
                itemCount: cart.items.length,
              ),
            ),
          ),

        ],
      ),

      floatingActionButton: Consumer<Cart>(
        builder: (_, cart, ch) => FloatingActionButton(
          onPressed: () {
            Provider.of<Orders>(context,listen: false).addOrder(
              cart.items.values.toList(),
              cart.totalAmount
            );

            cart.clear();
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: ch,
        ),

        child: Text('Order'),

      ),

    );
  }

}
