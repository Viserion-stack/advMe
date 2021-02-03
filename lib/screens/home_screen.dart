import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ads_screen.dart';
import 'orders_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        actions: [],
        title: Text('advMe'),
      ),
      body: Column(
        children: [
          SizedBox(height: 200),
          Text('Hello Admin'),
          SizedBox(height: 30),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 50.0, top: 30.0),
                    child: Column(
                      children: [
                        IconButton(
                          icon: Icon(Icons.add_business_outlined),
                          onPressed: () {
                            Navigator.pushNamed(
                                context, OrdersScreen.routeName);
                          },
                        ),
                        Text('Ad yourself'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 50.0, top: 30.0),
                    child: Column(
                      children: [
                        IconButton(
                          icon: Icon(Icons.person_search_outlined),
                            onPressed: () {
                            Navigator.pushNamed(
                                context, AdsScreen.routeName);
                          },
                        ),
                        Text('Look for order'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: null,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}