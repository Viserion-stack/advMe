import 'dart:ui';
import 'package:advMe/animation/bouncy_page_route.dart';
import 'package:advMe/providers/settings.dart';
import 'package:advMe/screens/account_screen.dart';
import 'package:advMe/screens/ads_screen.dart';
import 'package:advMe/widgets/all_orders.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final uid = FirebaseAuth.instance.currentUser.uid;

  dynamic getSettings;
  bool isDark;
  bool isNotif = false;
  String userName = '';
  String email = '';

  // Future<dynamic> getData() async {
  //   isDark = Provider.of<SettingsUser>(context).isDark;

  // }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      Provider.of<SettingsUser>(context, listen: false).getSettings();
    });
    // getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<SettingsUser>(context).isDark;
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          //color: Color(0xFFF3F3F3),
          image: DecorationImage(
            image: isDark
                ? AssetImage(
                    'assets/dark.png',
                  )
                : AssetImage(
                    'assets/grey.png',
                  ),
            fit: BoxFit.cover,
            
          ),
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
                      left: MediaQuery.of(context).size.width * 0.46,
                    ),
                    child: PopupMenuButton(
                      icon: Icon(
                        Icons.menu,
                        size: 35,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AccountScreen()));
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
                      color: isDark ? Color(0xFF00D1CD) : Color(0xFFFFD320),
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
                      color: isDark ? Colors.white : Colors.black,
                      fontSize: 32,
                      letterSpacing: 0.1,
                      fontWeight: FontWeight.w600,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: ' do?',
                        style: GoogleFonts.ubuntu(
                          color: isDark ? Color(0xFF00D1CD) : Color(0xFFFFD320),
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
                      if(isDark == false)
                      BoxShadow(
                        color: Colors.grey[300],
                        blurRadius: 10,
                        spreadRadius: 0.5,
                        offset: Offset(0, 8),
                      ),
                    ],
                    color: isDark ? Colors.transparent : Colors.white,
                    borderRadius: BorderRadius.circular(35),
                    border: Border.all(
                      color:isDark ? Color(0xFF15D4D0) : Colors.black,
                      width: isDark ? 2.0 : 0.08,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        color:isDark ? Color(0xFF15D4D0) : Colors.black,
                        size: 90,
                      ),
                      Text('Add yourself',
                          style: TextStyle(
                            color:isDark ? Color(0xFF15D4D0) : Colors.black,
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
                  Navigator.push(context, BouncyPageRoute(widget: AllOrders()));
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.51,
                  decoration: BoxDecoration(
                    boxShadow: [
                      if(isDark == false)
                      BoxShadow(
                        color: Colors.grey[300],
                        blurRadius: 10,
                        spreadRadius: 0.5,
                        offset: Offset(0, 8),
                      ),
                    ],
                    color: isDark ? Colors.transparent : Colors.white,
                    borderRadius: BorderRadius.circular(35),
                    border: Border.all(
                      color:isDark ? Color(0xFF15D4D0) : Colors.black,
                      width: isDark ? 2.0 : 0.08,
                    ),
                  ),

                  // MediaQuery.of(context).size.height * 0.08,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search,
                        color:isDark ? Color(0xFF15D4D0) : Colors.black,
                        size: 90,
                      ),
                      Text('Look for orders',
                          style: TextStyle(
                            color:isDark ? Color(0xFF15D4D0) : Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
