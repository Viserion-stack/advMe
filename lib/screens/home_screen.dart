import 'dart:ui';
import 'package:advMe/animation/bouncy_page_route.dart';
import 'package:advMe/providers/settings.dart';
import 'package:advMe/screens/ads_screen.dart';
import 'package:clip_shadow/clip_shadow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
      appBar: AppBar(
        backgroundColor: Color(0xFFFFD320),
        title: Row(children: [
          Image.asset(
            'assets/small_logo.png',
            fit: BoxFit.contain,
            height: 50,
            width: 100,
          ),
          Padding(
            padding: EdgeInsets.only(left: 180),
            child: GestureDetector(
              onTap: () {
                FirebaseAuth.instance.signOut();
              },
              child: Image.asset(
                'assets/quit_light.png',
                fit: BoxFit.cover,
                height: 30,
                width: 30,
              ),
            ),
          ),
        ]),
      ),

      //backgroundColor: settings.isDark ? Color(0xFFCA1538) : Color(0xFFE9ECF5),

      //Color(0xFFCA1538),
      //0xFFCA1538),

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
            Positioned(
              top: MediaQuery.of(context).size.height * 0.08,
              left: MediaQuery.of(context).size.width * 0.23,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, BouncyPageRoute(widget: AdsScreen()));
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.33,
                  width: MediaQuery.of(context).size.width * 0.55,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Color(0xFF00D1CD),
                      width: 4,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        color: Color(0xFF00D1CD),
                        size: 90,
                      ),
                      Text('Add yourself',
                          style: TextStyle(
                            color: Color(0xFF00D1CD),
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.44,
              left: MediaQuery.of(context).size.width * 0.23,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context, BouncyPageRoute(widget: OrdersScreen()));
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.33,
                  width: MediaQuery.of(context).size.width * 0.55,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Color(0xFF00D1CD),
                      width: 4,
                    ),
                  ),

                  // MediaQuery.of(context).size.height * 0.08,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search,
                        color: Color(0xFF00D1CD),
                        size: 90,
                      ),
                      Text('Look for orders',
                          style: TextStyle(
                            color: Color(0xFF00D1CD),
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * .79,
              left: MediaQuery.of(context).size.width * .75,
              child: Row(children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isDark = true;
                      settings.isDark = isDark;
                      _updateSettings();
                    });
                  },
                  child: isDark
                      ? Image.asset(
                          'assets/moon_dark.png',
                          fit: BoxFit.cover,
                          height: 60,
                          width: 40,
                        )
                      : Image.asset(
                          'assets/moon_light.png',
                          fit: BoxFit.cover,
                          height: 60,
                          width: 40,
                        ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isDark = false;
                      settings.isDark = isDark;
                      _updateSettings();
                    });
                  },
                  child: isDark
                      ? Image.asset(
                          'assets/sun_dark.png',
                          fit: BoxFit.cover,
                          height: 60,
                          width: 40,
                        )
                      : Image.asset(
                          'assets/sun_light.png',
                          fit: BoxFit.cover,
                          height: 60,
                          width: 40,
                        ),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
