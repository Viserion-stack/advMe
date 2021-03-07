import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';
import './orders_item.dart';

// ignore: must_be_immutable
class OrdersGrid extends StatelessWidget {
  bool isYourAds;
  final bool showFavs;

  OrdersGrid(this.showFavs, this.isYourAds);

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
          imageUrl1: orders[i].imageUrl1,
          imageUrl2: orders[i].imageUrl2,
          imageUrl3: orders[i].imageUrl3,
          isFavorite: orders[i].isFavorite,
          price: orders[i].price,
          phone: orders[i].phone,
          website: orders[i].website,
          address: orders[i].address,
          isYourAds: isYourAds,
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
