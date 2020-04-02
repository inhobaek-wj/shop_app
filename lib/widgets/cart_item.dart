import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../store/cart.dart';

class CartItem extends StatelessWidget {

  final String id;
  final String title;
  final double price;
  final int quantity;
  final String productId;

  const CartItem(this.id, this.title, this.price, this.quantity, this.productId);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),

      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical:  4
        ),
      ),

      direction: DismissDirection.endToStart,

      onDismissed: (direction) {
        Provider.of<Cart>(context,listen: false).removeItem(productId);
      },

      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4
        ),

        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: FittedBox(
                  child: Text('\$$price')
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${price * quantity}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }

}
