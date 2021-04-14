import 'package:advMe/animation/bouncy_page_route.dart';
import 'package:advMe/helpers/location_helper.dart';
import 'package:advMe/screens/account_screen.dart';
import 'package:advMe/screens/ads_editing_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:advMe/helpers/google_map_aplication_helper.dart';
import 'package:provider/provider.dart';
import 'package:advMe/providers/settings.dart';
import 'package:advMe/helpers/string_extenstion.dart';
import 'package:photo_view/photo_view.dart';

import 'home_screen.dart';

// ignore: must_be_immutable
class OrderDetailScreen extends StatefulWidget {
  static const routeName = '/orderl-detail';
  final String id;
  final String title;
  final String description;
  final bool isFavorite;
  final String imageUrl1;
  final String imageUrl2;
  final String imageUrl3;
  final String price;
  final String phone;
  final String website;
  final String address;
  bool isYourAds;
  double rating;
  int countRating;
  double sumRating;

  OrderDetailScreen({
    this.id,
    this.title,
    this.description,
    this.isFavorite,
    this.imageUrl1,
    this.imageUrl2,
    this.imageUrl3,
    this.price,
    this.phone,
    this.website,
    this.address,
    this.isYourAds,
    this.rating,
    this.countRating,
    this.sumRating,
  });

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  String _previewImageUrl;
  final List firebaseAllAdsInit = [];

  Future<void> launchURL(String url) async {
    if (!url.contains('http')) url = 'https://$url';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _makePhoneCall(String phone) async {
    var url = 'tel:$phone';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _deleteUserOrder(String id, String title) async {
    var firebaseUser = FirebaseAuth.instance.currentUser.uid;
    String itemToDelete1 = widget.title + '1.jpg';
    String itemToDelete2 = widget.title + '2.jpg';
    String itemToDelete3 = widget.title + '3.jpg';

    var storageReferance = FirebaseStorage.instance.ref();
    storageReferance
        .child('allAds/$firebaseUser/$itemToDelete1')
        .delete()
        .then((_) {
      print("Deleting image 1 from Storage success!");
    });

    storageReferance
        .child('allAds/$firebaseUser/$itemToDelete2')
        .delete()
        .then((_) {
      print("Deleting image 2 from Storage success!");
    });

    storageReferance
        .child('allAds/$firebaseUser/$itemToDelete3')
        .delete()
        .then((_) {
      print("Deleting image 3 from Storage success!");
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser)
        .collection("user_orders")
        .doc(widget.id)
        .delete()
        .then((_) {
      print("Deleting from Firebase 'user' success!");
    });

//TODO: Fix delete from allAds branch

    await FirebaseFirestore.instance
        .collection('allAds')
        .doc(widget.id)
        .delete()
        .then((_) {
      print("Deleting from Firebase 'allAds'success!");
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser)
        .collection("favorite")
        .doc(widget.id)
        .delete()
        .then((_) {
      print("Deleting from Firebase 'favorite'success!");
    });

    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure? '),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Are you sure to delete this Adevert? Press Yes to confirm or No to reject.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('NO'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('YES'),
              onPressed: () async {
                await _deleteUserOrder(widget.id, widget.title);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Order has beed deleted!'),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> userRating() async {
    //var uid = FirebaseAuth.instance.currentUser.uid;
    await FirebaseFirestore.instance
        .collection('allAds')
        .doc(widget.id)
        .collection('userRating')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((prodData) {
        firebaseAllAdsInit.add(
          prodData.data()['id'],
        );
      });
    });
  }

  @override
  void initState() {
    final staticMapImageUrl =
        LocationHelper.generateLocationPreviewImagebyAddress(widget.address);

    _previewImageUrl = staticMapImageUrl;
    userRating();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool changedRating = false;
    double ratingValue = 0.0;

    void updateRating() {
      bool isUser = false;
      var uid = FirebaseAuth.instance.currentUser.uid;
      double sum = 0.0;
      for (int i = 0; i < firebaseAllAdsInit.length; i++) {
        if (uid.toString() == firebaseAllAdsInit[i].toString()) {
          isUser = true;
          break;
        }
      }
      if (changedRating && !isUser) {
        sum = ratingValue + widget.sumRating;
        ratingValue = sum / (widget.countRating + 2);
        FirebaseFirestore.instance.collection('allAds').doc(widget.id).update({
          'rating': ratingValue,
          'countRating': widget.countRating + 1,
          'sumRating': sum,
        });
        FirebaseFirestore.instance
            .collection('allAds')
            .doc(widget.id)
            .collection('userRating')
            .doc(uid)
            .set({
          'id': uid,
        });
      }
    }

    if (widget.isYourAds == null) widget.isYourAds = false;
    final settings = Provider.of<SettingsUser>(context);

    print('sprawdzanie user rating: ' + firebaseAllAdsInit.toString());
    return Scaffold(
      backgroundColor: settings.isDark ? Color(0xFF171923) : Color(0xFFE9ECF5),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Color(0xFFF3F3F3),
            leading: new IconButton(
              icon: new Icon(
                Icons.chevron_left,
                color: Color(0xFFF8BB06),
                size: 46,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.title, style: TextStyle(color: Colors.black),),
              background: Hero(
                tag: widget.id,
                child: Column(children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.03,
                    ),
                    child: Row(children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.15,
                        ),
                        child: Image.asset(
                          'assets/small_logo.png',
                          fit: BoxFit.contain,
                          height: 60,
                          width: 120,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.30,
                          top: MediaQuery.of(context).size.height * 0.02,
                        ),
                        child: Icon(
                          Icons.search,
                          size: 35,
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.01,
                            top: MediaQuery.of(context).size.height * 0.02,
                          ),
                          child: PopupMenuButton(
                            icon: Icon(
                              Icons.menu,
                              size: 35,
                            ),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        BouncyPageRoute(
                                            widget: AccountScreen()));
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.account_circle,
                                        color: Colors.black,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text('Account',
                                          style:
                                              TextStyle(color: Colors.black)),
                                    ],
                                  ),
                                ),
                              ),
                              PopupMenuItem(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        BouncyPageRoute(widget: HomeScreen()));
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.home,
                                        color: Colors.black,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text('Home',
                                          style:
                                              TextStyle(color: Colors.black)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ]),
                  ),
                  Image.network(
                    widget.imageUrl1,
                    fit: BoxFit.contain,
                  ),
                ]),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(
                  height: 5000,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
