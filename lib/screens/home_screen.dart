import 'package:advMe/screens/categories_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
      backgroundColor: Color(0xFF73AEF5),
      body: Padding(
        padding: const EdgeInsets.all(80.0),
        child: Container(
          child: Stack(
            children: [
              Positioned(
                top: 110,
                child: Container(
                  child: ClipPath(
                    clipper: BackgroundClipperUp(),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.height * 0.4,
                      decoration: BoxDecoration(
                       
                        color: Color(0xFF3D59AB),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 225,
                child: Container(
                  child: ClipPath(
                    clipper: BackgroundClipper(),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.height * 0.4,
                      decoration: BoxDecoration(
                        color: Color(0xFF03A89E),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FirebaseAuth.instance.signOut();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
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
    path.lineTo(0, size.height - roundnessFactor);
    path.quadraticBezierTo(0, size.height, roundnessFactor, size.height);
    path.lineTo(size.width - roundnessFactor, size.height);
    path.quadraticBezierTo(
        size.width, size.height, size.width, size.height - roundnessFactor);
    path.lineTo(size.width, roundnessFactor * 2);
    path.quadraticBezierTo(
        size.width, 0, size.width - roundnessFactor * 3, roundnessFactor * 2);
    path.lineTo(roundnessFactor, size.height * 0.33 + 40);
    path.quadraticBezierTo(0, size.height * 0.33 + roundnessFactor + 20, 0,
        size.height * 0.33 + roundnessFactor * 2);

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

    path.moveTo(size.width, size.height - (size.height * 0.33));
    path.lineTo(size.width, 50);
    path.quadraticBezierTo(size.width, size.height - roundnessFactor * 6 + 30,
        roundnessFactor * 3 + 55, 0);
    path.lineTo(0 + roundnessFactor, 0);
    path.quadraticBezierTo(-4, -6, -5, size.height - roundnessFactor * 4);
    path.lineTo(0, size.height - roundnessFactor * 2);
    path.quadraticBezierTo(-5, size.height, 110, size.height - 85);
    path.lineTo(235, (size.height * 0.33) + 25);
    path.quadraticBezierTo(size.width + 35, (size.height * 0.33) - 35, 300,
        -(size.height * 0.33) * 4);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
