import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/cart.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {

  // final String id;
  // final String title;
  // final String imageUrl;

  // const ProductItem(
  //   this.id,
  //   this.title,
  //   this.imageUrl
  // );

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          ProductDetailScreen.routeName,
          arguments: product.id,
        );
      },

      child: GridTile(
        child: Image.network(
          product.imageUrl,
          fit: BoxFit.cover,
        ),

        footer: ClipRRect(
          borderRadius: BorderRadius.circular(10),

          child: GridTileBar(

            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),

            backgroundColor: Colors.black87,

            leading: Consumer<Product>(
              builder: (BuildContext context, Product product, Widget child) => IconButton(
                icon: Icon(
                  product.isFavorite ? Icons.favorite
                  : Icons.favorite_border),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  product.toggleFavorite();
                },
              ),
            ),

            trailing: IconButton(
              icon: const Icon(Icons.shopping_cart),
              color: Theme.of(context).accentColor,
              onPressed: () {
                cart.addItem(
                  product.id,
                  product.price,
                  product.title
                );
              },
            ),
          ),
        ),

      ),
    );
  }

}
