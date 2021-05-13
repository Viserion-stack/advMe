import 'dart:ui';
import 'package:advMe/providers/orders.dart';
import 'package:advMe/providers/user.dart' as user;
import 'package:advMe/screens/ads_screen.dart';
import 'package:advMe/widgets/all_orders.dart';
import 'package:advMe/widgets/app_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  final uid = FirebaseAuth.instance.currentUser.uid;

  dynamic getSettings;
  bool isNotif = false;
  String userName = '';
  String email = '';

  Widget build(BuildContext context) {
    Provider.of<Orders>(context, listen: false).fetchAndSetProducts();
    print('Pobieranie do providera');
    Provider.of<Orders>(context, listen: false).fetchFavorite();
    return FutureBuilder(
      future: Provider.of<user.User>(context, listen: false).getUserData(),
      builder: (ctx, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: SpinKitWave(
            color: Color(0xFF00D1CD),
          )
              //CircularProgressIndicator(),
              );
        }

        final isDark = Provider.of<user.User>(context).isDark;
        return SafeArea(
          child: Scaffold(
            key: _scaffoldState,
            drawer: AppDrawer(),
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
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
                      ),
                      IconButton(
                        icon: Icon(Icons.menu,
                            color: isDark ? Colors.white : Colors.black,
                            size: 35),
                        onPressed: () {
                          _scaffoldState.currentState.openDrawer();
                        },
                      ),
                    ]),
                  ),
                  Positioned(
                      top: MediaQuery.of(context).size.height * 0.12,
                      left: MediaQuery.of(context).size.width * 0.3,
                      child: Text('What',
                          style: GoogleFonts.ubuntu(
                            color:
                                isDark ? Color(0xFF00D1CD) : Color(0xFFFFD320),
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdsScreen()));
                      },
                      child: Container(
                        height: 180, //MediaQuery.of(context).size.height * 0.3,
                        width: 180, //MediaQuery.of(context).size.width * 0.51,
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
                                  fontSize: 24,
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
                                builder: (context) => AllOrders()));
                      },
                      child: Container(
                        height: 180, //MediaQuery.of(context).size.height * 0.3,
                        width: 180, // MediaQuery.of(context).size.width * 0.51,
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
                                  fontSize: 24,
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
        );
      },
    );
  }
}
