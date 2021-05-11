import 'package:advMe/screens/ads_screen.dart';
import 'package:advMe/screens/edit_profile.dart';
import 'package:advMe/providers/user.dart' as user;
import 'package:advMe/widgets/all_orders.dart';
import 'package:advMe/widgets/favorite_orders.dart';
import 'package:advMe/widgets/your_ads.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class DrawerScreen extends StatefulWidget {
  final AnimationController controller;

  const DrawerScreen({Key key, this.controller}) : super(key: key);

  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  Animation<double> _scaleAnimation;
  Animation<Offset> _slideAnimation;
  final uid = FirebaseAuth.instance.currentUser.uid;
  bool isDark = false;
  bool isNotif = false;

  void _updateSettings() async {
    FirebaseFirestore.instance.collection('users').doc(uid).update({
      'isDark': isDark,
      'isNotifications': isNotif,
    });
  }

  @override
  Widget build(BuildContext context) {
    final userPhotoUrl =
        Provider.of<user.User>(context, listen: false).imageUrl;
    final settings = Provider.of<user.User>(context, listen: false);
    if (_scaleAnimation == null) {
      _scaleAnimation =
          Tween<double>(begin: 0.6, end: 1).animate(widget.controller);
    }
    if (_slideAnimation == null) {
      _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
          .animate(widget.controller);
    }
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: settings.isDark ? Color(0xFF005B5B) : Color(0xFF009494),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.02,
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.02,
                          left: MediaQuery.of(context).size.width * 0.05,
                        ),
                        child: Container(
                          height: 50,
                          width: 100,
                          child: SvgPicture.asset(
                            'assets/logo_white.svg',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.1,
                  left: MediaQuery.of(context).size.width * 0.38,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        Container(
                            height: 150,
                            width: 150,
                            child: (userPhotoUrl == '')
                                ? Icon(
                                    Icons.account_circle,
                                    size: 170,
                                    color: settings.isDark
                                        ? Color(0xFF6A6A6A)
                                        : Color(0xFFCECECE),
                                  )
                                : Container(
                                    height: 200,
                                    width: 200,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: NetworkImage(userPhotoUrl),
                                          fit: BoxFit.cover),
                                    ),
                                  )),
                        Padding(
                          padding: EdgeInsets.only(top: 15.0),
                                                  child: Text(
                            'Johny Deep',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 15.0),
                          child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xFF00ECE7),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(15),
                                //color: Color(0xFFF8BB06),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 8.0,
                                  right: 8.0,
                                  top: 2,
                                  bottom: 2,
                                ),
                                child: Text(
                                  'BASIC plan',
                                  style: TextStyle(
                                      color: Color(0xFF00ECE7),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                              )),
                        ),
                      ]),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.48,
                  left: MediaQuery.of(context).size.width * 0.35,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdsScreen()));
                        },
                        child: Row(children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 2.0),
                            child: Container(
                              height: 29,
                              width: 29,
                              child: SvgPicture.asset('assets/plus.svg',
                                  color: Color(0xFF00ECE7)),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'Add Advertisment',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          )
                        ]),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AllOrders()));
                        },
                        child: Row(children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 2.0),
                            child: Container(
                              height: 29,
                              width: 29,
                              child: SvgPicture.asset('assets/lupa.svg',
                                  color: Color(0xFF00ECE7)),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Look for Orders',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          )
                        ]),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FavoriteOrders()));
                        },
                        child: Row(children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 2.0),
                            child: Container(
                              height: 29,
                              width: 29,
                              child: SvgPicture.asset('assets/serce.svg',
                                  color: Color(0xFF00ECE7)),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Yours Favourites',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          )
                        ]),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => YourAds()));
                        },
                        child: Row(children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 2.0),
                            child: Container(
                              height: 29,
                              width: 29,
                              child: SvgPicture.asset('assets/glosnik.svg',
                                  color: Color(0xFF00ECE7)),
                            ),
                          ),

                          // Icon(
                          //   Icons.campaign_outlined,
                          //   size: 35,
                          //   color: Color(0xFF00ECE7),
                          // ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            'Yours Advertisment',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          )
                        ]),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProfile()));
                        },
                        child: Row(children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 2.0),
                            child: Container(
                              height: 27,
                              width: 27,
                              child: SvgPicture.asset('assets/pencil.svg',
                                  color: Color(0xFF00ECE7)),
                            ),
                          ),
                          // Icon(
                          //   Icons.create,
                          //   size: 35,
                          //   color: Color(0xFF00ECE7),
                          // ),
                          SizedBox(
                            width: 16,
                          ),
                          Text(
                            'Edit Profile',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          )
                        ]),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.83,
                  left: MediaQuery.of(context).size.width * 0.35,
                  child: GestureDetector(
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                    },
                    child: Row(children: [
                      Container(
                        height: 32,
                        width: 32,
                        child: SvgPicture.asset(
                          'assets/logout.svg',
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Log out',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      )
                    ]),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.91,
                  left: MediaQuery.of(context).size.width * 0.7,
                  child: Row(children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          settings.isDark = true;
                          isDark = settings.isDark;
                          settings.setValues(isDark, isNotif);
                          _updateSettings();
                        });
                      },
                      child: Container(
                        height: 32,
                        width: 32,
                        child: SvgPicture.asset(
                          'assets/moon.svg',
                          color: settings.isDark
                              ? Color(0xFF00ECE7)
                              : Colors.white,
                        ),
                      ),
                    ),
                    // IconButton(
                    //   icon: Icon(
                    //     Icons.nightlight_round,
                    //     color:
                    //         settings.isDark ? Color(0xFF00D1CD) : Colors.white,
                    //     size: 35,
                    //   ),
                    //   onPressed: () {
                    //     setState(() {
                    //       settings.isDark = true;
                    //       isDark = settings.isDark;
                    //       settings.setValues(isDark, isNotif);
                    //       _updateSettings();
                    //     });
                    //   },
                    // ),
                    Container(
                      height: 32,
                      width: 32,
                      child: IconButton(
                        icon: Icon(
                          Icons.wb_sunny,
                          color: settings.isDark
                              ? Colors.white
                              : Color(0xFFFFD321),
                          size: 35,
                        ),
                        onPressed: () {
                          setState(() {
                            settings.isDark = false;
                            isDark = settings.isDark;
                            settings.setValues(isDark, isNotif);
                            _updateSettings();
                          });
                        },
                      ),
                    ),
                  ]),
                )
              ],
            )),
      ),
    );
  }
}
