import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../store/cart.dart';

enum FilterOptions {
  Fatorites,
  All
}

class ProductsOverviewScreen extends StatefulWidget {

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {

  bool _showOnlyFavorite = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert),

            onSelected: (FilterOptions value) {
              setState(() {
                  if (FilterOptions.Fatorites == value) {
                    _showOnlyFavorite = true;
                  } else {
                    _showOnlyFavorite = false;
                  }
              });
            },

            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.Fatorites
              ),

              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All
              ),

            ],
          ),

          Consumer<Cart>(
            builder: (BuildContext context, Cart cart, Widget ch) =>
            Badge(
              value: cart.itemCount.toString(),
              child: ch,
              // this child(ch) never rebuild,
              // even though state which is listened by provider is changed.
              // and it is Consumer's child.
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {  },
            )
          ),

        ],
      ),

      body: ProductsGrid(_showOnlyFavorite),
    );
  }
}
