import 'dart:ui';
import 'package:clip_shadow/clip_shadow.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';



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
                    color: Colors.black,
                    blurRadius: 40,
                    spreadRadius: 10,
                    offset: Offset(0.0, 1.0),
                  ),
                ],
                clipper: BackgroundClipperUp(),
              ),
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
                    color: Colors.black,
                    blurRadius: 40,
                    spreadRadius: 10,
                    offset: Offset(0.0, 1.0),
                  ),
                ],
                clipper: BackgroundClipper(),
              ),
            ],
          ),
          Positioned(
            left: MediaQuery.of(context).size.width / 6,
            top: MediaQuery.of(context).size.height * 0.11,
            right: MediaQuery.of(context).size.width / 6,
            child: RotationTransition(
              turns: AlwaysStoppedAnimation(0 / 360),
              child: ClipPath(
                clipper: BackgroundClipperButtonUp(),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60)),
                    //color: Color(0x80464656)
                  ),
                  width: 280,
                  height: 360,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(60),
                              topRight: Radius.circular(60)),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 20),
                            //child: RotationTransition(
                            //turns: AlwaysStoppedAnimation(345 / 360),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0x40303250),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(60),
                                    topRight: Radius.circular(60)),
                              ),
                              width: 190,
                              height: 230,
                            ),
                          ),
                        ),
                      ),
                      Center(
                          child: Column(children: [
                        SizedBox(
                          height: 60,
                        ),
                        Icon(
                          Icons.add_box,
                          size: 80,
                          color: Color(0xFFCBB2AB),
                        ),
                        Text(
                          'Add yourself',
                          style:
                              TextStyle(color: Color(0xFFF79E1B), fontSize: 30),
                        )
                      ])),
                      //),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width / 6,
            top: MediaQuery.of(context).size.height * 0.38,
            right: MediaQuery.of(context).size.width / 6,
            child: RotationTransition(
              turns: AlwaysStoppedAnimation(0 / 360),
              child: ClipPath(
                clipper: BackgroundClipperButtonDown(),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(60),
                        bottomRight: Radius.circular(60)),
                    
                  ),
                  width: 280,
                  height: 360,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(60),
                              bottomRight: Radius.circular(60)),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 20),
                            //child: RotationTransition(
                            //turns: AlwaysStoppedAnimation(345 / 360),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0x40303250),
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(60),
                                    bottomRight: Radius.circular(60)),
                              ),
                              width: 190,
                              height: 230,
                            ),
                          ),
                        ),
                      ),
                      Center(
                          child: Column(children: [
                        SizedBox(
                          height: 160,
                        ),
                        Icon(
                          Icons.add_box,
                          size: 80,
                          color: Color(0xFFF79E1B),
                        ),
                        Text(
                          'Add yourself',
                          style:
                              TextStyle(color: Color(0xFFCBB2AB), fontSize: 30),
                        )
                      ])),
                      //),
                    ],
                  ),
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
    

    var path = Path();

    path.moveTo(0, size.height * 0.33);

    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(0, size.height * 0.33 + 40);
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
    

    var path = Path();

    path.moveTo(size.width, size.height);

    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, (size.height * 0.33) + 70);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class BackgroundClipperButtonUp extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
 

    var path = Path();

    path.moveTo(size.width, size.height);

    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.lineTo(0, size.height - 50);
    path.lineTo(size.width, (size.height * 0.33) + 70);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class BackgroundClipperButtonDown extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
   

    var path = Path();

    path.moveTo(0, size.height * 0.33);

    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 50);
    path.lineTo(0, size.height * 0.33 + 50);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
