import 'package:advMe/screens/categories_screen.dart';
import 'package:clip_shadow/clip_shadow.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: unused_import
import 'ads_screen.dart';
import 'category_meals_screen.dart';
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
      //backgroundColor: LinearGradient(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFBD72B),
              Color(0xFFFFB904),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(80.0),
          child: Container(
            child: Stack(
              children: [
                Positioned(
                  top: 100,
                  child: Container(
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, AdsScreen.routeName);
                      },
                      child: ClipShadow(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black38,
                            blurRadius: 10,
                            spreadRadius: 0,
                            offset: Offset(0.0, 1.0),
                          ),
                          BoxShadow(
                            color: Colors.black38,
                            offset: const Offset(0.0, 0.0),
                            blurRadius: 0.0,
                            spreadRadius: 0.0,
                          ),
                        ],
                        clipper: BackgroundClipperUp(),
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 0,
                              top: 30.0,
                              right: 40,
                            ),
                            child: Column(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.add_business_outlined,
                                    size: 70,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {},
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                Text(
                                  'Ad yourself',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 30),
                                ),
                              ],
                            ),
                          ),
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: MediaQuery.of(context).size.height * 0.4,
                          decoration: BoxDecoration(
                            color: Color(0xFF006633),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 220,
                  child: Container(
                    child: InkWell(
                      onTap: () {
                        
                        Navigator.pushNamed(context, OrdersScreen.routeName);
                      },
                      child: ClipShadow(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black38,
                            blurRadius: 10,
                            spreadRadius: 0,
                            offset: Offset(0.0, 1.0),
                          ),
                          BoxShadow(
                            color: Colors.white,
                            offset: const Offset(0.0, 0.0),
                            blurRadius: 0.0,
                            spreadRadius: 0.0,
                          ),
                        ],
                        clipper: BackgroundClipper(),
                        child: Container(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(right: 20.0, top: 120.0),
                            child: Column(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.person_search_outlined,
                                      color: Colors.white, size: 70),
                                  onPressed: () {},
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                Text('Look for order',
                                    style: TextStyle(
                                        fontSize: 30, color: Colors.white)),
                              ],
                            ),
                          ),
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: MediaQuery.of(context).size.height * 0.4,
                          decoration: BoxDecoration(
                            color: Colors.blue[900],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  child: RichText(
                    text: TextSpan(
                        text: 'hello',
                        style: GoogleFonts.ubuntu(
                          color: Color(0xFFCD3700),
                          fontSize: 40.0,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w600,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Robert',
                            style: GoogleFonts.ubuntu(
                              color: Color(0xFF478DE0),
                              fontSize: 40.0,
                              letterSpacing: 0.1,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFCD3700),
        onPressed: () {
          FirebaseAuth.instance.signOut();
        },
        tooltip: 'Increment',
        child: Icon(Icons.logout),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class BackgroundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var roundnessFactor = 50.0;
    var path = Path();

    path.moveTo(0, size.height * 0.33);
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(0, size.height, roundnessFactor, size.height);
    path.lineTo(size.width - 50, size.height);
    path.quadraticBezierTo(
        size.width, size.height, size.width, size.height - roundnessFactor);
    path.lineTo(size.width, 50);
    //path.quadraticBezierTo(
    //    size.width, 0, size.width - roundnessFactor * 3, roundnessFactor * 2);
    path.lineTo(0, size.height * 0.33 + 40);
    //path.quadraticBezierTo(0, size.height * 0.33 + roundnessFactor + 20, 0,
    //    size.height * 0.33 + roundnessFactor * 2);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class BackgroundClipperUp extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var roundnessFactor = 50.0;
    var path = Path();

    path.moveTo(size.width, size.height);
    path.lineTo(size.width, 50);
    path.quadraticBezierTo(size.width, size.height - roundnessFactor * 6 + 30,
        roundnessFactor * 3 + 55, 0);
    path.lineTo(50, 0);
    path.quadraticBezierTo(-5, -5, 0, size.height - roundnessFactor * 4);
    path.lineTo(0, size.height - 40);
    //path.quadraticBezierTo(-5, size.height, 110, size.height - 85);
    path.lineTo(size.width, (size.height * 0.33) + 60);
    // path.quadraticBezierTo(size.width + 35, (size.height * 0.33) - 35, 300,
    //     -(size.height * 0.33) * 4);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
