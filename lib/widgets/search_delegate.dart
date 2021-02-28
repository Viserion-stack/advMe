import 'package:advMe/providers/orders.dart';
import 'package:advMe/screens/order_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Searchwidget extends StatefulWidget {
  Searchwidget({Key key}) : super(key: key);

  @override
  _SearchwidgetState createState() => _SearchwidgetState();
}

class _SearchwidgetState extends State<Searchwidget> {
  @override
  Widget build(BuildContext context) {
    final ads = Provider.of<Orders>(context, listen: false).itemstitles();
    return Scaffold(
      appBar: AppBar(
        title: Text('searchbar'),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: DataSearch(ads: ads));
              }),
        ],
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
//  final routeArgs =
//         ModalRoute.of(context).settings.arguments as Map<String, String>;
//     final categoryTitle = routeArgs['title'];
//     final categoryId = routeArgs['id'];
  // final categoryMeals = Order.where((meal) {
  //   return meal.categories.contains(categoryId);
  // }).toList();

  List<dynamic> ads;

  DataSearch({
    @required this.ads,
  });

  // final ads = [
  //   'Malowanie dachĂłw',
  //    'Remont Ĺ‚azienki',
  //   'Czyszczenie',
  //   'Transport',
  //   'Transportowanie',
  //   'Tranzition',
  //   'Czekanie',
  //   'Remapowanie',
  //   'Regipsy',
  // ];

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final orderstsData = Provider.of<Orders>(context);
    final orders = orderstsData.items;
    final existingOrderIndex = orders.indexWhere((ord) => ord.title == query);
    // TODO: implement buildResults
    return OrderDetailScreen(
      id: orders[existingOrderIndex].id,
      title: orders[existingOrderIndex].title,
      description: orders[existingOrderIndex].description,
      isFavorite: orders[existingOrderIndex].isFavorite,
      imageUrl: orders[existingOrderIndex].imageUrl,
      price: orders[existingOrderIndex].price,
      phone: orders[existingOrderIndex].phone,
      website: orders[existingOrderIndex].website,
      address: orders[existingOrderIndex].address,
    );

    // return Center(
    //   child: Text(
    //     query,
    //     style: TextStyle(
    //         color: Colors.blue, fontWeight: FontWeight.w900, fontSize: 30),
    //   ),
    // );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List recentads = ads;
    if (recentads.length <= 1) {
      recentads = ads.sublist(0, 1);
    } else if (recentads.length <= 2) {
      recentads = ads.sublist(0, 2);
    } else if (recentads.length <= 3) {
      recentads = ads.sublist(0, 3);
    } else {
      recentads = ads.sublist(0, 4);
    }

    final sugestionList = query.isEmpty
        ? recentads
        : ads.where((p) => p.startsWith(query.toLowerCase())).toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        leading: Icon(Icons.location_city),
        title: RichText(
          text: TextSpan(
            text: sugestionList[index].substring(0, query.length),
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                text: sugestionList[index].substring(query.length),
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
      itemCount: sugestionList.length,
    );
  }
}
