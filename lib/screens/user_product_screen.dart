import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';
import '../screens/edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {

  static const routeName = '/user-product';

  Future<void> _refreshProducts(BuildContext ctx) async {
    await Provider.of<Products>(ctx, listen: false).fetchProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // the line below should be commented,
    // because FutureBuilder is used, and it causes infinite loop.
    // final productsData = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          )
        ],
      ),

      drawer: AppDrawer(),

      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (context, AsyncSnapshot snapshot) =>
        snapshot.connectionState == ConnectionState.waiting ?
        Center(child: CircularProgressIndicator(),)
        : RefreshIndicator(
          onRefresh: () => _refreshProducts(context),

          child: Consumer<Products>(
            builder: (_, productsData, child) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: productsData.items.length,

                itemBuilder: (context, index) => Column(
                  children: <Widget>[
                    UserProductItem(
                      productsData.items[index].id,
                      productsData.items[index].title,
                      productsData.items[index].imageUrl,
                      productsData.deleteProduct
                    ),

                    Divider(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

    );
  }

}
