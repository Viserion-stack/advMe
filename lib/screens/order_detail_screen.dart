import 'package:advMe/helpers/location_helper.dart';
import 'package:advMe/screens/account_screen.dart';
import 'package:advMe/screens/ads_editing_screen.dart';
import 'package:advMe/screens/home_screen.dart';
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
import 'package:advMe/providers/user.dart' as user;
import 'package:advMe/helpers/string_extenstion.dart';
import 'package:photo_view/photo_view.dart';

// ignore: must_be_immutable
class OrderDetailScreen extends StatefulWidget {
  static const routeName = '/orderl-detail';
  final String userId;
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
    this.userId,
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

// ignore: todo
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

  // ignore: unused_element
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

    // ignore: unused_element
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
    final settings = Provider.of<user.User>(context, listen: false);
    ScrollController _scrollController = ScrollController()
      ..addListener(() => setState(() {}));

    print('sprawdzanie user rating: ' + firebaseAllAdsInit.toString());
    return Scaffold(
      backgroundColor: settings.isDark ? Color(0xFF3C3C3C) : Color(0xFFF3F3F3),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
            floating: false,
            expandedHeight: 500,
            backgroundColor:
                settings.isDark ? Color(0xFF3C3C3C) : Color(0xFFF3F3F3),
            leading: new IconButton(
              icon: new Icon(
                Icons.chevron_left,
                color: settings.isDark ? Color(0xFF00D1CD) : Color(0xFFF8BB06),
                size: 46,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            //expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsetsDirectional.only(start: 50, bottom: 16, top: 10),
              title: Text(
                widget.title.capitalize(),
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: settings.isDark ? Color(0xFFD4D4D4) : Colors.black),
              ),
              background: Column(children: [
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
                        settings.isDark
                            ? 'assets/small_logo_dark.png'
                            : 'assets/small_logo.png',
                        fit: BoxFit.contain,
                        height: 60,
                        width: 120,
                      ),
                    ),
                    
                  ]),
                ),
                Expanded(
                  child: Hero(
                    tag: widget.id,
                    child: PhotoViewGallery(
                      pageOptions: <PhotoViewGalleryPageOptions>[
                        PhotoViewGalleryPageOptions(
                          imageProvider: NetworkImage(widget
                              .imageUrl1), 
                              minScale: PhotoViewComputedScale.contained * 1.5,
                              maxScale: PhotoViewComputedScale.covered * 1.5,
                              //AssetImage("assets/gallery1.jpg"),
                          //heroAttributes: const PhotoViewHeroAttributes(tag: "tag1"),
                        ),
                        PhotoViewGalleryPageOptions(
                            imageProvider: NetworkImage(widget
                                .imageUrl2), //AssetImage("assets/gallery2.jpg"),
                            //heroAttributes:
                            //const PhotoViewHeroAttributes(tag: "tag2"),
                            minScale: PhotoViewComputedScale.contained * 1.5,
                            maxScale: PhotoViewComputedScale.covered * 1.5),
                        PhotoViewGalleryPageOptions(
                          imageProvider: NetworkImage(widget
                              .imageUrl3), //AssetImage("assets/gallery3.jpg"),
                          minScale: PhotoViewComputedScale.contained * 1.5,
                          maxScale: PhotoViewComputedScale.covered * 1.5,
                          //heroAttributes: const PhotoViewHeroAttributes(tag: "tag3"),
                        ),
                      ],
                      loadingBuilder: (context, progress) => Center(
                        child: Container(
                          width: 70.0,
                          height: 50.0,
                          child: SpinKitWave(
                            color: Color(0xFF00D1CD),
                          ),
                        ),
                      ),
                      backgroundDecoration: BoxDecoration(
                        color: settings.isDark
                            ? Color(0xFF3C3C3C)
                            : Color(
                                0xFFF3F3F3), //TOO inny kolor dla dark screen
                      ),
                      //backgroundDecoration: widget.backgroundDecoration,
                      //pageController: widget.pageController,
                      // onPageChanged: onPageChanged,
                    ),
                  ),
                ),
                Container(
                  height: 70,
                  width: double.infinity,
                )
              ]),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20),
                  child: Container(
                    //width: MediaQuery.of(context).size.width *.4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Row(children: [
                          Expanded(
                            child: Text(
                              '${widget.price} zł',
                              style: TextStyle(
                                color: settings.isDark
                                    ? Color(0xFFD4D4D4)
                                    : Color(0xFFFFD320),
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Row(children: [
                            Icon(
                              Icons.star,
                              color: Color(0xFFFFD320),
                              size: 25,
                            ),
                            SizedBox(width: 5),
                            Text(
                              widget.rating.toStringAsPrecision(2),
                              style: TextStyle(
                                  fontSize: 30,
                                  color: settings.isDark
                                      ? Color(0xFFD4D4D4)
                                      : Colors.black,
                                  fontWeight: FontWeight.w700),
                            ),
                          ])
                        ]),
                        SizedBox(height: 25),
                        Text(
                          widget.description,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 18,
                            color: settings.isDark
                                ? Color(0xFFD4D4D4)
                                : Colors.black,
                          ),
                        ),
                        SizedBox(height: 25),
                        GestureDetector(
                            onTap: () => launchURL(widget.website),
                            child: Container(
                              //alignment: Alignment.topCenter,
                              height: 60,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: settings.isDark
                                        ? Color(0x00000029)
                                        : Colors.grey[300],
                                    blurRadius: 10,
                                    spreadRadius: 0.5,
                                    offset: Offset(0, 8),
                                  ),
                                ],
                                color: settings.isDark
                                    ? Color(0xFF009494)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 0.2,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        .32),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.language,
                                      color: settings.isDark
                                          ? Colors.white
                                          : Color(0xFFFFD320),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Website',
                                      style: TextStyle(
                                        color: settings.isDark
                                            ? Colors.white
                                            : Color(0xFFFFD320),
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                        SizedBox(height: 25),
                        Container(
                          //height: 170,
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: _previewImageUrl == null
                              ? Text(
                                  'No Location Choosen',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white54),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: settings.isDark
                                            ? Color(0x00000029)
                                            : Colors.grey[300],
                                        blurRadius: 12,
                                        spreadRadius: 0.9,
                                        offset: Offset(0, 8),
                                      ),
                                    ],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 0.8,
                                    ),
                                  ),
                                  width: double.infinity,
                                  height: 170,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      _previewImageUrl,
                                      fit: BoxFit.cover,
                                      //width: double.infinity,
                                    ),
                                  ),
                                ),
                        ),
                        SizedBox(height: 15),
                        Row(children: [
                          Expanded(
                              child: GestureDetector(
                            onTap: () => _makePhoneCall(widget.phone),
                            child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  color: settings.isDark
                                      ? Color(0xFF11BF84)
                                      : Color(0x0FF24E46A),
                                  boxShadow: [
                                    BoxShadow(
                                      color: settings.isDark
                                          ? Color(0x00000029)
                                          : Colors.grey[300],
                                      blurRadius: 10,
                                      spreadRadius: 0.5,
                                      offset: Offset(0, 8),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(22),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 0.2,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          .12),
                                  child: Row(children: [
                                    Icon(
                                      Icons.phone,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Call',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ]),
                                )),
                          )),
                          SizedBox(width: 10),
                          Expanded(
                              child: GestureDetector(
                            onTap: () => MapUtils.openMap(widget.address),
                            child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  color: settings.isDark
                                      ? Color(0xFF00D1CD)
                                      : Color(0xFFFFD320),
                                  boxShadow: [
                                    BoxShadow(
                                      color: settings.isDark
                                          ? Color(0x00000029)
                                          : Colors.grey[300],
                                      blurRadius: 10,
                                      spreadRadius: 0.5,
                                      offset: Offset(0, 8),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(22),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 0.2,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          .09),
                                  child: Row(children: [
                                    Icon(
                                      Icons.near_me,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Navigate',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ]),
                                )),
                          ))
                        ]),
                        SizedBox(height: 30),
                        if (widget.userId !=
                            FirebaseAuth.instance.currentUser.uid)
                          Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * .17),
                            child: Row(
                              children: [
                                Text('Rate',
                                    style: TextStyle(
                                      color: Color(0xFFFFD320),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    )),
                                SizedBox(width: 5),
                                Container(
                                    child: RatingBar(
                                  itemSize: 35,
                                  //unratedColor: Color(0xFFFFD320),
                                  initialRating: 0.0,
                                  ratingWidget: RatingWidget(
                                    full: Icon(
                                      Icons.star,
                                      color: Color(0xFFFFD320),
                                      size: 12,
                                    ),
                                    half: Icon(
                                      Icons.star_half,
                                      color: Color(0xFFFFD320),
                                      size: 12,
                                    ),
                                    empty: Icon(
                                      Icons.star_border,
                                      color: Color(0xFFFFD320),
                                      size: 12,
                                    ),
                                  ),
                                  itemCount: 5,
                                  allowHalfRating: true,
                                  direction: Axis.horizontal,
                                  minRating: 1.0,
                                  maxRating: 5.0,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 0.2),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                    changedRating = true;
                                    ratingValue = rating;
                                  },
                                )),
                              ],
                            ),
                          ),
                        if (widget.userId ==
                            FirebaseAuth.instance.currentUser.uid)
                          Padding(
                            padding: EdgeInsets.only(left: 1),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AdsEditingScreen(
                                              title: widget.title,
                                              description: widget.description,
                                              price: widget.price,
                                              phone: widget.phone,
                                              imageUrl1: widget.imageUrl1,
                                              imageUrl2: widget.imageUrl2,
                                              imageUrl3: widget.imageUrl3,
                                              website: widget.website,
                                              address: widget.address,
                                            )));

                                // Navigator.push(
                                //     context,
                                //     BouncyPageRoute(
                                //         widget: AdsEditingScreen(
                                //       title: widget.title,
                                //       description: widget.description,
                                //       price: widget.price,
                                //       phone: widget.phone,
                                //       imageUrl1: widget.imageUrl1,
                                //       imageUrl2: widget.imageUrl2,
                                //       imageUrl3: widget.imageUrl3,
                                //       website: widget.website,
                                //       address: widget.address,
                                //     )));
                              },
                              child: Container(
                                height: 60,
                                //width: 320,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: settings.isDark
                                            ? Color(0x00000029)
                                            : Colors.grey[300],
                                        blurRadius: 10,
                                        spreadRadius: 0.5,
                                        offset: Offset(0, 8),
                                      ),
                                    ],
                                    color: settings.isDark
                                        ? Color(0xFF3C3C3C)
                                        : Color(0xFFF3F3F3),
                                    borderRadius: BorderRadius.circular(22),
                                    border: Border.all(
                                      width: settings.isDark ? 1.5 : 0.0,
                                      color: settings.isDark
                                          ? Color(0xFF00D1CD)
                                          : Color(0xFFF8BB06),
                                    )),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.edit,
                                        color: settings.isDark
                                            ? Color(0xFF00D1CD)
                                            : Color(0xFFF8BB06),
                                      ),
                                      SizedBox(width: 5),
                                      Text('Edit Advertisment',
                                          style: GoogleFonts.quicksand(
                                            color: settings.isDark
                                                ? Color(0xFF00D1CD)
                                                : Color(0xFFF8BB06),
                                            fontSize: 19,
                                            fontWeight: FontWeight.w600,
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        SizedBox(height: 25),
                        Container(
                          height: 2,
                          width: double.infinity,
                          color: settings.isDark
                              ? Color(0xFF707070)
                              : Colors.grey[350],
                        ),
                        SizedBox(height: 25),
                        Center(
                            child: Text('advMe! 2021',
                                style: TextStyle(
                                  color: settings.isDark
                                      ? Color(0xFF707070)
                                      : Colors.grey[350],
                                ))),
                        SizedBox(height: 25),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
