import 'package:flutter/material.dart';

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
    return GridTile(
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

    );
  }

}
