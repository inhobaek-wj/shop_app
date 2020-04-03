import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {

  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product')
      ),

      // body: ListView.builder(
      //   itemCount: orderData.orders.length,

      //   itemBuilder: (context, index) => OrderItem(
      //     orderData.orders[index]
      //   ),
      // ),

    );
  }
}
