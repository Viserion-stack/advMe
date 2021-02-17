import 'dart:ui';

//import 'package:advMe/animation/bouncy_page_route.dart';
import 'package:advMe/screens/order_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:page_transition/page_transition.dart';

class OrdersItem extends StatelessWidget {
  final String id;
  final String description;
  final bool isFavorite;
  final String imageUrl;

  OrdersItem({
    @required this.id,
    @required this.description,
    @required this.isFavorite,
    @required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var username = FirebaseAuth.instance.currentUser.displayName.toString();
    return InkWell(
      onTap: () {
        Navigator.push(
            context, PageTransition(
              type: PageTransitionType.fade,
            child: OrderDetailScreen(
                id,
                description,
                isFavorite,
                imageUrl,
              ),
            ));
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Card(
            color: Color(0x40303250),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 4,
            margin: EdgeInsets.all(5),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30, sigmaY: 5),
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
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(children: <Widget>[
                        Text(
                          description,
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
                            '300 EUR',
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
