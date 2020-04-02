import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/products_overview_screen.dart';
import 'screens/product_detail_screen.dart';
import 'store/products.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    // return ChangeNotifierProvider(
    // builder: (ctx) => Products(),

    return ChangeNotifierProvider.value(
      value: Products(), // if don't need ctx, you can use value() method like the line above.

      // about ChangeNotifierProvider.
      // it makes sure that provider works even if data changes for the widget.
      // ChangeNotifierProvider cleans up data when widget is disposed.
      // Since provider version 3.2.0 "builder" is marked as deprecated in favor of "create".

      child: MaterialApp(
        title: 'Flutter Demo',

        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),

        home: ProductsOverviewScreen(),

        routes: {
          ProductDetailScreen.routeName : (ctx) => ProductDetailScreen(),
        },
      ),
    );
  }
}
