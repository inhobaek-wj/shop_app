import 'package:flutter/material.dart';

import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {

  final String id;
  final String title;
  final String imageUrl;

  const ProductItem(
    this.id,
    this.title,
    this.imageUrl
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          ProductDetailScreen.routeName,
          arguments: id,
        );
      },

      child: GridTile(
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),

        footer: ClipRRect(
          borderRadius: BorderRadius.circular(10),

          child: GridTileBar(
            title: Text(
              title,
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.black87,
            leading: IconButton(
              icon: const Icon(Icons.favorite),
              color: Theme.of(context).accentColor,
              onPressed: () {},
            ),

            trailing: IconButton(
              icon: const Icon(Icons.shopping_cart),
              color: Theme.of(context).accentColor,
              onPressed: () {},
            ),
          ),
        ),

      ),
    );
  }

}
