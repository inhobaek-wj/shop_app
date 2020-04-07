import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/products_overview_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/user_product_screen.dart';
import 'screens/edit_product_screen.dart';
import 'screens/auth_screen.dart';
import 'providers/products.dart';
import 'providers/cart.dart';
import 'providers/order.dart';
import 'providers/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    // return ChangeNotifierProvider(
    // builder: (ctx) => Products(),

    return MultiProvider(
      providers: <SingleChildCloneableWidget>[
        ChangeNotifierProvider.value(
          value: Products(), // if don't need ctx, you can use value() method like the line above.

          // about ChangeNotifierProvider.
          // it makes sure that provider works even if data changes for the widget.
          // ChangeNotifierProvider cleans up data when widget is disposed.
          // Since provider version 3.2.0 "builder" is marked as deprecated in favor of "create".
        ),

        ChangeNotifierProvider.value(
          value: Cart(),
        ),

        ChangeNotifierProvider.value(
          value: Orders(),
        ),

        ChangeNotifierProvider.value(
          value: Auth(),
        ),

      ],

      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Flutter Demo',

          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),

          home: auth.isAuth ? ProductsOverviewScreen() : AuthScreen(),

          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName:  (ctx) => CartScreen(),
            OrdersScreen.routeName:  (ctx) => OrdersScreen(),
            UserProductScreen.routeName:  (ctx) => UserProductScreen(),
            EditProductScreen.routeName:  (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
