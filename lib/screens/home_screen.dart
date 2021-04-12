import 'dart:ui';
import 'package:advMe/animation/bouncy_page_route.dart';
import 'package:advMe/providers/settings.dart';
import 'package:advMe/screens/account_screen.dart';
import 'package:advMe/screens/ads_screen.dart';
import 'package:clip_shadow/clip_shadow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'orders_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final uid = FirebaseAuth.instance.currentUser.uid;

  dynamic getSettings;
  bool isDark = false;
  bool isNotif = false;
  String userName = '';
  String email = '';

  Future<dynamic> getData() async {
    final DocumentReference document =
        FirebaseFirestore.instance.collection('users').doc(uid);
    await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        isDark = snapshot.data()['isDark'];
        isNotif = snapshot.data()['isNotifications'];
        userName = snapshot.data()['username'];
        email = snapshot.data()['email'];
      });
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  void _updateSettings() async {
    FirebaseFirestore.instance.collection('users').doc(uid).update({
      'isDark': isDark,
      'isNotifications': isNotif,
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsUser>(context);
    if (settings.isDark == null) isDark = false;

    isNotif = settings.isNotifications;
    //final uid = FirebaseAuth.instance.currentUser.uid;
    FirebaseFirestore.instance.collection('users').doc(uid).get();
    settings.setValues(
      isDark,
      isNotif,
      //userName,
      // email,
    );
    print(isDark.toString());
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Color(0xFFF3F3F3),
          // image: DecorationImage(
          //   image: AssetImage(
          //     'assets/screen.jpeg',
          //   ),
          //   fit: BoxFit.cover,
          // ),
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
                              Navigator.push(
                      context, BouncyPageRoute(widget: AccountScreen()));
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.verified_user,
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
                      ],
                    )),
              ]),
            ),
            Positioned(
                top: MediaQuery.of(context).size.height * 0.14,
                left: MediaQuery.of(context).size.width * 0.3,
                child: Text('What',
                    style: GoogleFonts.ubuntu(
                      color: Color(0xFFFFD320),
                      fontSize: 43,
                      letterSpacing: 0.1,
                      fontWeight: FontWeight.w600,
                    ))),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.2,
              left: MediaQuery.of(context).size.width * 0.19,
              child: RichText(
                text: TextSpan(
                    text: 'would like to',
                    style: GoogleFonts.ubuntu(
                      color: Colors.black,
                      fontSize: 32,
                      letterSpacing: 0.1,
                      fontWeight: FontWeight.w600,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: ' do?',
                        style: GoogleFonts.ubuntu(
                          color: Color(0xFFFFD320),
                          fontSize: 43,
                          letterSpacing: 0.1,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ]),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.32,
              left: MediaQuery.of(context).size.width * 0.25,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, BouncyPageRoute(widget: AdsScreen()));
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.51,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[300],
                        blurRadius: 10,
                        spreadRadius: 0.5,
                        offset: Offset(0, 8),
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(35),
                    border: Border.all(
                      color: Colors.black,
                      width: 0.08,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.black,
                        size: 90,
                      ),
                      Text('Add yourself',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.65,
              left: MediaQuery.of(context).size.width * 0.25,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context, BouncyPageRoute(widget: OrdersScreen()));
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.51,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[300],
                        blurRadius: 10,
                        spreadRadius: 0.5,
                        offset: Offset(0, 8),
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(35),
                    border: Border.all(
                      color: Colors.black,
                      width: 0.08,
                    ),
                  ),

                  // MediaQuery.of(context).size.height * 0.08,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search,
                        color: Colors.black,
                        size: 90,
                      ),
                      Text('Look for orders',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                ),
              ),
            ),
            // Positioned(
            //   top: MediaQuery.of(context).size.height * .79,
            //   left: MediaQuery.of(context).size.width * .75,
            //   child: Row(children: [
            //     GestureDetector(
            //       onTap: () {
            //         setState(() {
            //           isDark = true;
            //           settings.isDark = isDark;
            //           _updateSettings();
            //         });
            //       },
            //       child: isDark
            //           ? Image.asset(
            //               'assets/moon_dark.png',
            //               fit: BoxFit.cover,
            //               height: 60,
            //               width: 40,
            //             )
            //           : Image.asset(
            //               'assets/moon_light.png',
            //               fit: BoxFit.cover,
            //               height: 60,
            //               width: 40,
            //             ),
            //     ),
            //     GestureDetector(
            //       onTap: () {
            //         setState(() {
            //           isDark = false;
            //           settings.isDark = isDark;
            //           _updateSettings();
            //         });
            //       },
            //       child: isDark
            //           ? Image.asset(
            //               'assets/sun_dark.png',
            //               fit: BoxFit.cover,
            //               height: 60,
            //               width: 40,
            //             )
            //           : Image.asset(
            //               'assets/sun_light.png',
            //               fit: BoxFit.cover,
            //               height: 60,
            //               width: 40,
            //             ),
            //     ),
            //   ]),
            // )
          ],
        ),
      ),
    );
  }
}
