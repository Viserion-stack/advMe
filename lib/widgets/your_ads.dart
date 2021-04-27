//import 'package:animations/animations.dart';
import 'package:advMe/animation/bouncy_page_route.dart';
import 'package:advMe/providers/settings.dart';
import 'package:advMe/screens/account_screen.dart';
import 'package:advMe/screens/home_screen.dart';
import 'package:advMe/widgets/order_grid_item.dart';
import 'package:flutter/material.dart';

//import 'package:advMe/widgets/category_item.dart';
import 'package:advMe/widgets/orders_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class YourAds extends StatefulWidget {
  @override
  _YourAdsState createState() => _YourAdsState();
}

class _YourAdsState extends State<YourAds> {
  @override
  Widget build(BuildContext context) {
    var userId = FirebaseAuth.instance.currentUser.uid;
    //final transitionType = ContainerTransitionType.fade;
    final settings = Provider.of<SettingsUser>(context);
    bool isYourAds = true;

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: settings.isDark ? Color(0xFFF3F3F3) : Color(0xFFF3F3F3),
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
                    'assets/small_logo.png',
                    fit: BoxFit.contain,
                    height: 60,
                    width: 120,
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.5,
                      top: MediaQuery.of(context).size.height * 0.02,
                    ),
                    child: PopupMenuButton(
                      icon: Icon(
                        Icons.menu,
                        size: 35,
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  BouncyPageRoute(widget: AccountScreen()));
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
                              Navigator.push(context,
                                  BouncyPageRoute(widget: HomeScreen()));
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
            Padding(padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.17,
                      top: MediaQuery.of(context).size.height * 0.15,
                    ),
                    child: Text('Yours Advertisment',
                style: GoogleFonts.quicksand(
                  fontSize: 28,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                )),),
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
                      color: Color(0xFFF79E1B),
                    )
                        //CircularProgressIndicator(),
                        );
                  }

                  print('Ilość załadowanych ogłoszeń streambuilderem ' +
                      orderSnapshot.data.docs.length.toString());
                  return GridView.builder(
                    cacheExtent: 1000,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 2 / 3.2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    reverse: false,
                    itemCount: orderSnapshot.data.docs.length,
                    itemBuilder: (ctx, index) {
                      DocumentSnapshot userData =
                          orderSnapshot.data.docs[index];

                      return OrderGridItem(
                        description: userData.data()['description'],
                        id: userData.id,
                        title: userData.data()['title'],
                        imageUrl1: userData.data()['imageUrl1'],
                        imageUrl2: userData.data()['imageUrl2'],
                        imageUrl3: userData.data()['imageUrl3'],
                        isFavorite: false,
                        price: userData.data()['price'],
                        phone: userData.data()['phone'],
                        website: userData.data()['website'],
                        address: userData.data()['address'],
                        countRating: 1,
                        rating: 3.5,
                        sumRating: 7,
                        //category: userData.data()['address'],
                        isYourAds: isYourAds,
                      );
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
