import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/order.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

// class OrdersScreen extends StatefulWidget

//   @override
//   _OrdersScreenState createState() => _OrdersScreenState();
// }

// class _OrdersScreenState extends State<OrdersScreen> {
// bool _isLoading = false;

// @override
// void initState() {

//   Future.delayed(Duration.zero).then((_) async {
//       setState(() {
//           _isLoading = true;
//       });

//       await Provider.of<Orders>(context, listen: false).fetchOrders();

//       setState(() {
//           _isLoading = false;
//       });
//   });

//   super.initState();
// }

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

      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchOrders(),
        builder: (ctx, dataSnapshot) {

          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return  Center(
              child: CircularProgressIndicator(),
            );
          } else {

            if (dataSnapshot.error != null) {
              return Center(
                child: Text('An error occured!'),
              );

            } else {
              return ListView.builder(
                itemCount: orderData.orders.length,

                itemBuilder: (context, index) => OrderItem(
                  orderData.orders[index]
                ),
              );
            }

          }
        },

      ),

    );
  }
}
