import 'package:advMe/providers/orders.dart';
import 'package:advMe/providers/user.dart' as user;
import 'package:advMe/screens/account_screen.dart';
import 'package:advMe/screens/home_screen.dart';
import 'package:advMe/widgets/order_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FavoriteOrders extends StatefulWidget {
  @override
  _FavoriteOrdersState createState() => _FavoriteOrdersState();
}

class _FavoriteOrdersState extends State<FavoriteOrders> {
  @override
  Widget build(BuildContext context) {
    var userId = FirebaseAuth.instance.currentUser.uid;
   final settings = Provider.of<user.User>(context,listen: false);
   final allOrders = Provider.of<Orders>(context,listen: false);
    bool isYourAds = false;

    return Scaffold(
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
                      left: MediaQuery.of(context).size.width * 0.45,
                      top: MediaQuery.of(context).size.height * 0.02,
                    ),
                    child: PopupMenuButton(
                      icon: Icon(
                        Icons.menu,
                        size: 35,
                        color:
                            settings.isDark ? Color(0xFF7D7D7D) : Colors.black,
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AccountScreen()));
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.account_circle,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('Account',
                                    style: TextStyle(color: Colors.black)),
                              ],
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()));
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.home,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('Home',
                                    style: TextStyle(color: Colors.black)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
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
                  child: Text('Your Favourites',
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
                    .collection('favorite')
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
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 2 / 3.2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    cacheExtent: 1000,
                    reverse: false,
                    itemCount: orderSnapshot.data.docs.length,
                    itemBuilder: (ctx, index) {
                       DocumentSnapshot userData =
                          orderSnapshot.data.docs[index];
                      for(int i = 0; i< allOrders.items.length; i++){
                        if(userData.id.toString() == allOrders.items[i].id){
                          return OrderGridItem(
                        userId: allOrders.items[i].userId,
                        description: allOrders.items[i].description,
                        id: allOrders.items[i].id,
                        title: allOrders.items[i].title,
                        imageUrl1: allOrders.items[i].imageUrl1,
                        imageUrl2: allOrders.items[i].imageUrl2,
                        imageUrl3: allOrders.items[i].imageUrl3,
                        isFavorite: true,
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
