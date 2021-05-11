import 'dart:ui';
import 'package:advMe/providers/orders.dart';
import 'package:advMe/providers/user.dart' as user;
import 'package:advMe/screens/ads_screen.dart';
import 'package:advMe/screens/layout_screen.dart';
import 'package:advMe/widgets/all_orders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final AnimationController controller;
  final Duration duration;

  const HomeScreen({Key key, this.controller, this.duration}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final uid = FirebaseAuth.instance.currentUser.uid;

  double tranx = 0, trany = 0, scale = 1.0;
  bool menuOpen = false;
  Animation<double> _scaleAnimation;

  dynamic getSettings;
  bool isNotif = false;
  String userName = '';
  String email = '';

  Widget build(BuildContext context) {
    if (_scaleAnimation == null) {
      _scaleAnimation =
          Tween<double>(begin: 1, end: 0.6).animate(widget.controller);
    }
    var size = MediaQuery.of(context).size;
    final userData = Provider.of<user.User>(context, listen: false);
    final isDark = Provider.of<user.User>(context).isDark;
    Provider.of<Orders>(context, listen: false).fetchAndSetProducts();
    print('Pobieranie do providera');
    Provider.of<Orders>(context, listen: false).fetchFavorite();
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          if (menuOpen) {
            setState(() {
              scale = 1.0;
              tranx = 0;
              trany = 0;
              widget.controller.reverse();
              menuOpen = false;
            });
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          transform: Matrix4.translationValues(tranx, trany, 0)..scale(scale),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: isDark ? Color(0xEE3C3C3C) : Colors.black12,
                  blurRadius: 8,
                  spreadRadius: 0,
                  offset: Offset(10, 0),
                ),
                BoxShadow(
                  color: isDark ? Color(0xAA3C3C3C) : Colors.black12,
                  blurRadius: 8,
                  spreadRadius: 0,
                  offset: Offset(10, 8),
                ),
              ],
              //color: Colors.white,
              borderRadius: BorderRadius.circular(menuOpen ? 45 : 0)),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(menuOpen ? 45 : 0),
              //color: Color(0xFFF3F3F3),
              image: DecorationImage(
                image: isDark
                    ? AssetImage(
                        'assets/dark.jpg',
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
                        isDark
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
                      ),
                      child: !menuOpen
                          ? IconButton(
                              icon: Icon(
                                Icons.menu,
                                size: 35,
                              ),
                              onPressed: () {
                                scale = 0.6;
                                tranx = size.width - 580;
                                trany = (size.height - size.height * scale) / 2;
                                setState(() {
                                  widget.controller.forward();
                                  menuOpen = true;
                                });
                              },
                              color: isDark ? Colors.white : Colors.black,
                            )
                          : IconButton(
                              icon: Icon(
                                Icons.chevron_right,
                                size: 35,
                              ),
                              onPressed: () {
                                setState(() {
                                  scale = 1.0;
                                  tranx = 0;
                                  trany = 0;
                                  widget.controller.reverse();
                                  menuOpen = false;
                                });
                              },
                              color: isDark ? Colors.white : Colors.black,
                            ),
                    ),
                  ]),
                ),
                Positioned(
                    top: MediaQuery.of(context).size.height * 0.12,
                    left: MediaQuery.of(context).size.width * 0.3,
                    child: Text('What',
                        style: GoogleFonts.ubuntu(
                          color: isDark ? Color(0xFF00D1CD) : Color(0xFFFFD320),
                          fontSize: 43,
                          letterSpacing: 0.1,
                          fontWeight: FontWeight.w600,
                        ))),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.17,
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
                              color: isDark
                                  ? Color(0xFF00D1CD)
                                  : Color(0xFFFFD320),
                              fontSize: 43,
                              letterSpacing: 0.1,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ]),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.31,
                  left: MediaQuery.of(context).size.width * 0.25,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AdsScreen()));
                    },
                    child: Container(
                      height: 200, //MediaQuery.of(context).size.height * 0.3,
                      width: 200, //MediaQuery.of(context).size.width * 0.51,
                      decoration: BoxDecoration(
                        boxShadow: [
                          if (isDark == false)
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
                          color: isDark ? Color(0xFF15D4D0) : Colors.black,
                          width: isDark ? 2.0 : 0.08,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            color: isDark ? Color(0xFF15D4D0) : Colors.black,
                            size: 90,
                          ),
                          Text('Add yourself',
                              style: TextStyle(
                                color:
                                    isDark ? Color(0xFF15D4D0) : Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.62,
                  left: MediaQuery.of(context).size.width * 0.25,
                  child: GestureDetector(
                    onTap: () {
                      //userData.setScreenIndex(1);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LayoutScreen(screen: 1,)));
                    },
                    child: Container(
                      height: 200, //MediaQuery.of(context).size.height * 0.3,
                      width: 200, // MediaQuery.of(context).size.width * 0.51,
                      decoration: BoxDecoration(
                        boxShadow: [
                          if (isDark == false)
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
                          color: isDark ? Color(0xFF15D4D0) : Colors.black,
                          width: isDark ? 2.0 : 0.08,
                        ),
                      ),

                      // MediaQuery.of(context).size.height * 0.08,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search,
                            color: isDark ? Color(0xFF15D4D0) : Colors.black,
                            size: 90,
                          ),
                          Text('Look for orders',
                              style: TextStyle(
                                color:
                                    isDark ? Color(0xFF15D4D0) : Colors.black,
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
        ),
      ),
      //);
      //},
    );
  }
}
