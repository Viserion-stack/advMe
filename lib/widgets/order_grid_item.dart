import 'dart:ui';

//import 'package:advMe/animation/bouncy_page_route.dart';
import 'package:advMe/providers/settings.dart';
import 'package:advMe/screens/order_detail_screen.dart';
import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final value = widget.address;
    String city = '';

    if (value == null) {
      city = 'No localization available';
    } else {
      final value = widget.address.split(',');
      int count = value.length;
      city = value[count - 2];
    }

    final settings = Provider.of<SettingsUser>(context);
    // ignore: unused_local_variable
    var username = FirebaseAuth.instance.currentUser.displayName.toString();
    return OpenContainer(
      openElevation: 0,
      closedElevation: 0,
      transitionDuration: Duration(milliseconds: 500),
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
        countRating: widget.countRating,
        sumRating: widget.sumRating,
      ),
      closedBuilder: (context, _) => Container(
        decoration: BoxDecoration(
          boxShadow: [],
        ),
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                  child: Image.network(
                    widget.imageUrl1,
                    height: 200,
                    width: MediaQuery.of(context).size.width, //130,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * .028,
                  left: MediaQuery.of(context).size.width * .35,
                  child: widget.isYourAds
                      ? GestureDetector(
                          onTap: () {
                            //TODO: Create screen to edit your advertisment
                          },
                          child: Container(
                            width: 27,
                            height: 27,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x00000029),
                                    blurRadius: 4,
                                    spreadRadius: 0.5,
                                    offset: Offset(0, 2),
                                  ),
                                ]),
                            child: Icon(
                              Icons.edit,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              widget.isFavorite = !widget.isFavorite;
                              return _addFavorite(widget.isFavorite);
                            });
                          },
                          child: Icon(
                            widget.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Color(0xFFFFD320),
                          ),
                        ),
                ),
              ]),

              Padding(
                padding: EdgeInsets.only(left: 8.0, top: 10),
                child: Text(
                  widget.title.capitalize(),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              //  ),
              Row(
                children: [
                  SizedBox(width: 5),
                  Icon(Icons.place, size: 18),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      value == null
                          ? 'No localizatoin available'
                          : city.substring(7, city.length),
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(children: [
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    child: Text(
                      '${widget.price} zł',
                      style: GoogleFonts.lexendDeca(
                        letterSpacing: 0,
                        color: Color(0xFFFFD320),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Row(children: [
                  Icon(
                    Icons.star,
                    color: Color(0xFFFFD320),
                  ),
                  Text(
                    widget.rating.toStringAsPrecision(2),
                    style: GoogleFonts.lexendDeca(
                        fontSize: 17,
                        color: Colors.black,
                        fontWeight: FontWeight.w700),
                  ),
                ]),
                SizedBox(width: 10),
              ]),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
