import 'dart:ui';

//import 'package:advMe/animation/bouncy_page_route.dart';
import 'package:advMe/providers/settings.dart';
import 'package:advMe/screens/order_detail_screen.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class OrdersItem extends StatelessWidget {
  final String id;
  final String title;
  final String description;
  final bool isFavorite;
  final String imageUrl;
  final String price;
  final String phone;
  final String website;
  final String address;

  OrdersItem({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.isFavorite,
    @required this.imageUrl,
    @required this.price,
    @required this.phone,
    @required this.website,
    @required this.address,
  });

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsUser>(context);
    // ignore: unused_local_variable
    var username = FirebaseAuth.instance.currentUser.displayName.toString();
    return OpenContainer(
      openElevation: 0,
      closedElevation: 0,
      transitionDuration: Duration(milliseconds: 650),
      transitionType: ContainerTransitionType.fade,
      closedColor: settings.isDark ? Colors.transparent : Color(0xFFE9ECF5),
      openColor: settings.isDark ? Color(0xFF171923) : Color(0xFFE9ECF5),
      openBuilder: (context, _) => OrderDetailScreen(
        id: id,
        title: title,
        description: description,
        isFavorite: isFavorite,
        imageUrl: imageUrl,
        price: price,
        phone: phone,
        website: website,
        address: address,
      ),
      closedBuilder: (context, _) => Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Card(
            color: settings.isDark ? Color(0x40303250) : Color(0x55387CFF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 4,
            margin: EdgeInsets.all(2),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: settings.isDark ? 30 : 30,
                  sigmaY: settings.isDark ? 5 : 25,
                ),
                child: Row(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        //topRight: Radius.circular(5),
                        bottomLeft: Radius.circular(15),
                      ),
                      child: Image.network(
                        imageUrl,
                        height: 130,
                        width: 130,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(children: <Widget>[
                        Text(
                          title,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          child: Text(
                            '$price zł',
                            style: TextStyle(
                              color: Color(0xFFC31331),
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                            child: Row(children: [
                          Icon(
                            Icons.star,
                            color: Color(0xFFF79E1B),
                          ),
                          Icon(
                            Icons.star,
                            color: Color(0xFFF79E1B),
                          ),
                          Icon(
                            Icons.star,
                            color: Color(0xFFF79E1B),
                          ),
                          Icon(
                            Icons.star_border,
                            color: Color(0xFFF79E1B),
                          ),
                          Icon(
                            Icons.star_border,
                            color: Color(0xFFF79E1B),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            '3.2',
                            style: TextStyle(
                                fontSize: 26,
                                color: Color(0xFFF79E1B),
                                fontWeight: FontWeight.w700),
                          ),
                        ])),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
