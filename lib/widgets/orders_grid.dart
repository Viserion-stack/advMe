import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';
import './orders_item.dart';

// ignore: must_be_immutable
class OrdersGrid extends StatelessWidget {
  bool isYourAds;
  final bool showFavs;
  final String categoryName;

  OrdersGrid(this.showFavs, this.isYourAds,this.categoryName );

  @override
  Widget build(BuildContext context) {
    print('rebuild');
    final orderstsData = Provider.of<Orders>(context);
    //final products = showFavs ? productsData.favoriteItems : productsData.items;

    var categoryOrders = orderstsData.items.where((order) {
      return order.category.contains(categoryName);
    }).toList();

    final orders = orderstsData.items;

    if (categoryName =='All')
    {
    categoryOrders = orders;
    }
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: categoryOrders.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        // builder: (c) => products[i],
        value: categoryOrders[i],
        child: OrdersItem(
          description: categoryOrders[i].description,
          id: categoryOrders[i].id,
          title: categoryOrders[i].title,
          imageUrl1: categoryOrders[i].imageUrl1,
          imageUrl2: categoryOrders[i].imageUrl2,
          imageUrl3: categoryOrders[i].imageUrl3,
          isFavorite: categoryOrders[i].isFavorite,
          price: categoryOrders[i].price,
          phone: categoryOrders[i].phone,
          website: categoryOrders[i].website,
          address: categoryOrders[i].address,
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
