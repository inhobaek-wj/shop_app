import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/order.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {

  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Order')
      ),

      drawer: AppDrawer(),

      body: ListView.builder(
        itemCount: orderData.orders.length,

        itemBuilder: (context, index) => OrderItem(
          orderData.orders[index]
        ),
      ),

    );
  }

}
