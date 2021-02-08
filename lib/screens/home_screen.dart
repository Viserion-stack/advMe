import 'dart:ui';

import 'package:advMe/screens/categories_screen.dart';

import 'package:clip_shadow/clip_shadow.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:flutter/rendering.dart';

import 'package:google_fonts/google_fonts.dart';

import 'ads_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFCA1538),
        //0xFFCA1538),

      body: Stack(
        children: [
          Column(
            children: [
              ClipShadow(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF171923),
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 30,
                    spreadRadius: 0,
                    offset: Offset(0.0, 1.0),
                  ),
                ],
                clipper: BackgroundClipperUp(),
              ),

              // ignore: missing_required_param

              ClipShadow(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF171923),
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 30,
                    spreadRadius: 0,
                    offset: Offset(0.0, 1.0),
                  ),
                ],
                clipper: BackgroundClipper(),
              ),
            ],
          ),
          Positioned(
            left: 40,
            top: 120,
            child: RotationTransition(
              turns: AlwaysStoppedAnimation(10 / 360),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    const Radius.circular(80.0),
                  ),
                  //color: Color(0x80464656)
                ),
                width: 190,
                height: 250,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          const Radius.circular(60.0),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 20),
                          //child: RotationTransition(
                          //turns: AlwaysStoppedAnimation(345 / 360),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0x40303250),
                              borderRadius: BorderRadius.all(
                                const Radius.circular(60.0),
                              ),
                            ),
                            width: 190,
                            height: 230,
                          ),
                        ),
                      ),
                    ),
                    Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          Icon(
                            Icons.add_box,
                            size: 80,
                            color: Color(0xFFCBB2AB),
                          ),
                          Text(
                            'Add yourself',
                            style: TextStyle(
                                color: Color(0xFFF79E1B), fontSize: 30),
                          )
                        ])),
                    //),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: 50,
            top: 310,
            child: RotationTransition(
              turns: AlwaysStoppedAnimation(350 / 360),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    const Radius.circular(80.0),
                  ),
                  //color: Color(0x80464656)
                ),
                width: 190,
                height: 250,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          const Radius.circular(60.0),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 20),
                          //child: RotationTransition(
                          //turns: AlwaysStoppedAnimation(345 / 360),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0x40303250),
                              borderRadius: BorderRadius.all(
                                const Radius.circular(60.0),
                              ),
                            ),
                            width: 190,
                            height: 230,
                          ),
                        ),
                      ),
                    ),
                    Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          Icon(
                            Icons.add_box,
                            size: 80,
                            color: Color(0xFFF79E1B),
                          ),
                          Text(
                            'Add yourself',
                            style: TextStyle(
                                color: Color(0xFFCBB2AB), fontSize: 30),
                          )
                        ])),
                    //),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFF79E1B),
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

    path.lineTo(0, size.height);

    //path.quadraticBezierTo(0, size.height, roundnessFactor, size.height);

    path.lineTo(size.width, size.height);

    // path.quadraticBezierTo(

    //   size.width, size.height, size.width, size.height - roundnessFactor);

    path.lineTo(size.width, 0);

    //path.quadraticBezierTo(

    //    size.width, 0, size.width - roundnessFactor * 3, roundnessFactor * 2);

    path.lineTo(0, size.height * 0.33 + 60);

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

    path.lineTo(size.width, 0);

    //path.quadraticBezierTo(size.width, size.height - roundnessFactor * 6 + 30,

    //    roundnessFactor * 3 + 55, 0);

    path.lineTo(0, 0);

    //path.quadraticBezierTo(-5, -5, 0, size.height - roundnessFactor * 4);

    path.lineTo(0, size.height);

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
