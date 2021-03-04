import 'dart:ui';

//import 'package:advMe/animation/bouncy_page_route.dart';
import 'package:advMe/providers/settings.dart';
import 'package:advMe/screens/order_detail_screen.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:advMe/helpers/string_extenstion.dart';

class OrderGridItem extends StatelessWidget {
  final String id;
  final String title;
  final String description;
  final bool isFavorite;
  final String imageUrl;
  final String price;
  final String phone;
  final String website;
  final String address;
  bool isYourAds;

  OrderGridItem({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.isFavorite,
    @required this.imageUrl,
    @required this.price,
    @required this.phone,
    @required this.website,
    @required this.address,
    this.isYourAds,
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
        closedColor: settings.isDark
            ? Colors.transparent
            : Colors.transparent, //Color(0xFFE9ECF5),
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
              isYourAds: isYourAds,
            ),
        closedBuilder: (context, _) =>
            // SizedBox(
            //     width: MediaQuery.of(context).size.width,
            //     height:  MediaQuery.of(context).size.height,
            //     child:
            Card(
              color: settings.isDark
                  ? Color(0x40303250)
                  : Color(0xFFE3E6ED), //Color(0x55387CFF),
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
                    child: Column(children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          //bottomRight: Radius.circular(15),
                          //bottomLeft: Radius.circular(15),
                        ),
                        child: Image.network(
                          imageUrl,
                          //height: 200,
                          width: MediaQuery.of(context).size.width, //130,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(1),
                        child: Text(
                          title.capitalize(),
                          style: TextStyle(
                            color: settings.isDark
                                ? Colors.white
                                : Color(0xFF0D276B),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          '$price zł',
                          style: TextStyle(
                            color: Color(0xFFC31331),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        child: Row(children: <Widget>[
                          SizedBox(
                            width: 20,
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
                            width: 5,
                          ),
                          Text(
                            '3.2',
                            style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFFF79E1B),
                                fontWeight: FontWeight.w700),
                          ),
                        ]),
                      ),
                    ])),
              ),
            ));
  }
}
