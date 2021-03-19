import 'dart:ui';

//import 'package:advMe/animation/bouncy_page_route.dart';
import 'package:advMe/providers/settings.dart';
import 'package:advMe/screens/order_detail_screen.dart';
import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:advMe/helpers/string_extenstion.dart';

// ignore: must_be_immutable
class OrderGridItem extends StatefulWidget {
  final String id;
  final String title;
  final String description;
  bool isFavorite;
  final String imageUrl1;
  final String imageUrl2;
  final String imageUrl3;
  final String price;
  final String phone;
  final String website;
  final String address;
  final bool isYourAds;
  double rating;
  int countRating;
  double sumRating;

  OrderGridItem({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.isFavorite,
    @required this.imageUrl1,
    @required this.imageUrl2,
    @required this.imageUrl3,
    @required this.price,
    @required this.phone,
    @required this.website,
    @required this.address,
    this.isYourAds,
    this.rating,
    this.countRating,
    this.sumRating,

  });

  @override
  _OrderGridItemState createState() => _OrderGridItemState();
}

class _OrderGridItemState extends State<OrderGridItem> {
  Future<void> _addFavorite(bool state) {
    var userId = FirebaseAuth.instance.currentUser.uid;
    if (state) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorite')
          .doc(widget.id)
          .set({
        'Id': widget.id,
        'title': widget.title,
        'description': widget.description,
        'imageUrl1': widget.imageUrl1,
        'imageUrl2': widget.imageUrl2,
        'imageUrl3': widget.imageUrl3,
        'isFavorite': widget.isFavorite,
        //'userId': uid,
        'price': widget.price,
        'phone': widget.phone,
        'website': widget.website,
        'address': widget.address,
      });
    }
    if (!state) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection("favorite")
          .doc(widget.id)
          .delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsUser>(context);
    // ignore: unused_local_variable
    var username = FirebaseAuth.instance.currentUser.displayName.toString();
    return OpenContainer(
        closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
          ),
        ),
        openShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
          ),
        ),
        openElevation: 0,
        closedElevation: 0,
        transitionDuration: Duration(milliseconds: 650),
        transitionType: ContainerTransitionType.fade,
        closedColor: settings.isDark
            ? Colors.transparent
            : Colors.transparent, //Color(0xFFE9ECF5),
        openColor: settings.isDark ? Color(0xFF171923) : Color(0xFFE9ECF5),
        openBuilder: (context, _) => OrderDetailScreen(
              id: widget.id,
              title: widget.title,
              description: widget.description,
              isFavorite: widget.isFavorite,
              imageUrl1: widget.imageUrl1,
              imageUrl2: widget.imageUrl2,
              imageUrl3: widget.imageUrl3,
              price: widget.price,
              phone: widget.phone,
              website: widget.website,
              address: widget.address,
              isYourAds: widget.isYourAds,
              rating: widget.rating,
              countRating : widget.countRating,
              sumRating: widget.sumRating,
            ),
        closedBuilder: (context, _) =>
            // SizedBox(
            //     width: MediaQuery.of(context).size.width,
            //     height:  MediaQuery.of(context).size.height,
            //     child:
            Card(
              color: settings.isDark
                  ? Color(0x55303250)
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
                  bottomLeft: Radius.circular(15),
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
                          widget.imageUrl1,
                          //height: 200,
                          width: MediaQuery.of(context).size.width, //130,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(1),
                        child: Text(
                          widget.title.capitalize(),
                          style: TextStyle(
                            color: settings.isDark
                                ? Colors.white
                                : Color(0xFF0D276B),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(children: [
                        SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            child: Text(
                              '${widget.price} zł',
                              style: TextStyle(
                                color: Color(0xFFC31331),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Row(children: [
                          Icon(
                            Icons.star,
                            color: Color(0xFFF79E1B),
                          ),
                          Text(
                            widget.rating.toStringAsPrecision(2),
                            style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFFF79E1B),
                                fontWeight: FontWeight.w700),
                          ),
                        ]),
                        SizedBox(width: 10),
                      ]),
                      SizedBox(height: 10),
                      Row(children: [
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Localization',
                            style: TextStyle(
                              color: settings.isDark
                                  ? Colors.white
                                  : Color(0xFF0D276B),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                widget.isFavorite = !widget.isFavorite;
                               return  _addFavorite(widget.isFavorite);
                              });
                            },
                            child: Icon(
                              widget.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Color(0xEEC31331),
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                      ]),
                      SizedBox(height: 10),
                    ])),
              ),
            ));
  }
}
