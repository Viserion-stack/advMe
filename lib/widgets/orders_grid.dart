import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';
import './orders_item.dart';

class OrdersGrid extends StatelessWidget {
  final bool showFavs;

  OrdersGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    print('rebuild');
    final orderstsData = Provider.of<Orders>(context);
    //final products = showFavs ? productsData.favoriteItems : productsData.items;
    final orders = orderstsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: orders.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        // builder: (c) => products[i],
        value: orders[i],
        child: OrdersItem(
          description: orders[i].description,
          id: orders[i].id,
          title: orders[i].title,
          imageUrl: orders[i].imageUrl,
          isFavorite: orders[i].isFavorite,
          price: orders[i].price,
          phone: orders[i].phone,
          website: orders[i].website,
          address: orders[i].address,
        ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
