import 'package:advMe/providers/orders.dart';
import 'package:advMe/providers/user.dart' as user;

import 'package:advMe/widgets/app_drawer.dart';
import 'package:advMe/widgets/order_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class YourAds extends StatefulWidget {
  @override
  _YourAdsState createState() => _YourAdsState();
}

class _YourAdsState extends State<YourAds> {
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var userId = FirebaseAuth.instance.currentUser.uid;
    final settings = Provider.of<user.User>(context, listen: false);
    final allOrders = Provider.of<Orders>(context, listen: false);
    bool isYourAds = true;

    return Scaffold(
      key: _scaffoldState,
      drawer: AppDrawer(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: settings.isDark ? Color(0xFF3C3C3C) : Color(0xFFF3F3F3),
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.03,
              ),
              child: Row(children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.05,
                  ),
                  child: Image.asset(
                    settings.isDark
                        ? 'assets/small_logo_dark.png'
                        : 'assets/small_logo.png',
                    fit: BoxFit.contain,
                    height: 60,
                    width: 120,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.46,
                    top: MediaQuery.of(context).size.height * 0.02,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.menu,
                        color:
                            settings.isDark ? Color(0xFF959595) : Colors.black,
                        size: 35),
                    onPressed: () {
                      _scaffoldState.currentState.openDrawer();
                    },
                  ),
                ),
              ]),
            ),
            Padding(
              padding: EdgeInsets.only(
                //left: MediaQuery.of(context).size.width * 0.17,
                top: MediaQuery.of(context).size.height * 0.15,
              ),
              child: Container(
                height: 30,
                width: double.infinity,
                child: Center(
                  child: Text('Your Advertisment',
                      style: GoogleFonts.quicksand(
                        fontSize: 28,
                        color:
                            settings.isDark ? Color(0xFF00D1CD) : Colors.black,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 150.0, left: 6, right: 6, bottom: 6),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .collection('user_orders')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> orderSnapshot) {
                  if (orderSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                        child: SpinKitWave(
                      color: Color(0xFF00D1CD),
                    )
                        //CircularProgressIndicator(),
                        );
                  }

                  print('Ilość załadowanych ogłoszeń streambuilderem ' +
                      orderSnapshot.data.docs.length.toString());
                  return StaggeredGridView.countBuilder(
                          staggeredTileBuilder: (_) => StaggeredTile.fit(1),
                          mainAxisSpacing: 0.1,
                          crossAxisSpacing: 0.1,
                          crossAxisCount: 2,
                    itemCount: orderSnapshot.data.docs.length,
                    itemBuilder: (ctx, index) {
                      DocumentSnapshot userData =
                          orderSnapshot.data.docs[index];
                      for (int i = 0; i < allOrders.items.length; i++) {
                        if (userData.data()['userId'] ==
                                allOrders.items[i].userId &&
                            userData.data()['id'] == allOrders.items[i].id) {
                          return OrderGridItem(
                            userId: allOrders.items[i].userId,
                            description: allOrders.items[i].description,
                            id: allOrders.items[i].id,
                            title: allOrders.items[i].title,
                            imageUrl1: allOrders.items[i].imageUrl1,
                            imageUrl2: allOrders.items[i].imageUrl2,
                            imageUrl3: allOrders.items[i].imageUrl3,
                            // isFavorite: false,
                            price: allOrders.items[i].price,
                            phone: allOrders.items[i].phone,
                            website: allOrders.items[i].website,
                            address: allOrders.items[i].address,
                            countRating: allOrders.items[i].countRating,
                            rating: allOrders.items[i].rating,
                            sumRating: allOrders.items[i].sumRating,
                            //category: userData.data()['address'],
                            isYourAds: isYourAds,
                          );
                          //break;
                        }
                      }

                      return null;
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
