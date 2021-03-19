import 'package:advMe/helpers/location_helper.dart';
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.07,
            ),
            Row(children: [
              GestureDetector(
                onTap: () {
                  updateRating();
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Container(
                      width: 60,
                      height: 60,
                      child: Icon(
                        Icons.chevron_left,
                        color: settings.isDark
                            ? Color(0xFFF79E1B)
                            : Color(0xFFFFC03D),
                        size: 40,
                      ),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: settings.isDark
                              ? Color(0x40303250)
                              : Color(0xFF0D276B))),
                ),
              ),
              if (widget.isYourAds)
                Padding(
                  padding: const EdgeInsets.only(
                    right: 20,
                    left: 250,
                    bottom: 5,
                  ),
                  child: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: settings.isDark
                            ? Color(0xFFF79E1B)
                            : Color(0xEEC31331),
                        size: 37,
                      ),
                      onPressed: () {
                        _showMyDialog();
                      }),
                ),
            ]),
            SizedBox(
              height: 30,
            ),

            Container(
              //padding: const EdgeInsets.all(10.0),
              height: 350,
              width: MediaQuery.of(context).size.width * 1,
              child: PhotoViewGallery(
                pageOptions: <PhotoViewGalleryPageOptions>[
                  PhotoViewGalleryPageOptions(
                    imageProvider: NetworkImage(
                        widget.imageUrl1), //AssetImage("assets/gallery1.jpg"),
                    heroAttributes: const PhotoViewHeroAttributes(tag: "tag1"),
                  ),
                  PhotoViewGalleryPageOptions(
                      imageProvider: NetworkImage(widget
                          .imageUrl2), //AssetImage("assets/gallery2.jpg"),
                      heroAttributes:
                          const PhotoViewHeroAttributes(tag: "tag2"),
                      maxScale: PhotoViewComputedScale.contained * 0.3),
                  PhotoViewGalleryPageOptions(
                    imageProvider: NetworkImage(
                        widget.imageUrl3), //AssetImage("assets/gallery3.jpg"),
                    minScale: PhotoViewComputedScale.contained * 0.8,
                    maxScale: PhotoViewComputedScale.covered * 1.1,
                    heroAttributes: const PhotoViewHeroAttributes(tag: "tag3"),
                  ),
                ],
                loadingBuilder: (context, progress) => Center(
                  child: Container(
                    width: 70.0,
                    height: 50.0,
                    child: SpinKitWave(
                      color: Color(0xFFF79E1B),
                    ),
                  ),
                ),
                backgroundDecoration: BoxDecoration(
                  color:
                      settings.isDark ? Color(0xFF171923) : Color(0xFFE9ECF5),
                ),
                //backgroundDecoration: widget.backgroundDecoration,
                //pageController: widget.pageController,
                // onPageChanged: onPageChanged,
              ),
              // child: Swiper(
              //   itemCount: 3,
              //   itemWidth: MediaQuery.of(context).size.width - 2 * 64,
              //   layout: SwiperLayout.STACK,
              //   pagination: SwiperPagination(
              //       builder: DotSwiperPaginationBuilder(
              //     activeSize: 10,
              //     space: 0,
              //   )),
              //   itemBuilder: (_, index) {
              //     List images = [
              //       widget.imageUrl1,
              //       widget.imageUrl2,
              //       widget.imageUrl3
              //     ];
              //     print(images);
              //     return Stack(children: [
              //       Card(
              //           color: settings.isDark
              //               ? Color(0xFFCA1538)
              //               : Color(0xFFE9ECF5),
              //           elevation: 8,
              //           shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(40),
              //           ),
              //           child: Image.network(images[index])),
              //     ]);
              //   },
              // ),
            ),
            SizedBox(
              height: 30,
            ),
            Positioned(
              left: MediaQuery.of(context).size.width * 0.2,
              top: 100,
              child: Text(
                widget.title.capitalize(),
                style: GoogleFonts.ubuntu(
                  color:
                      settings.isDark ? Color(0xFFF79E1B) : Color(0xFF0D276B),
                  fontSize: 40.0,
                  //letterSpacing: .5,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),

            SizedBox(
              height: 20,
            ),

            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Text(
                widget.price + ' PLN',
                style: TextStyle(
                  color: Color(0xEEC31331),
                  fontSize: 30,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Divider(
              color: settings.isDark ? Color(0xFFF79E1B) : Color(0xAA0D276B),
              thickness: 0.5,
              //height: 100,
              endIndent: 30,
              indent: 30,
            ),
            SizedBox(
              height: 30,
            ),

            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: Text(
                widget.description,
                style: TextStyle(
                  fontFamily: 'Avenir',
                  color: settings.isDark ? Colors.white54 : Color(0xAA0D276B),
                  fontSize: 22,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Divider(
              color: settings.isDark ? Color(0xFFF79E1B) : Color(0xFF0D276B),
              thickness: 0.5,
              endIndent: 30,
              indent: 30,
            ),
            //LocationInput(),
            SizedBox(
              height: 30,
            ),
            Container(
              //height: 170,
              //width: double.infinity,
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
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      width: 200,
                      height: 200,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(150),
                        child: Image.network(
                          _previewImageUrl,
                          fit: BoxFit.cover,
                          //width: double.infinity,
                        ),
                      ),
                    ),
            ),

            SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: settings.isDark
                          ? Color(0xEEC31331)
                          : Color(0xFFF1554C),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.phone_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        _makePhoneCall(widget.phone);
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: settings.isDark
                          ? Color(0xFFCBB2AB)
                          : Color(0xEE387CFF),
                    ),
                    child: IconButton(
                        icon: Icon(
                          Icons.open_in_browser_outlined,
                          color: settings.isDark
                              ? Color(0xFF303250)
                              : Colors.white,
                        ),
                        onPressed: () {
                          launchURL(widget.website);
                        }),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: settings.isDark
                          ? Color(0xFFF79E1B)
                          : Color(0xFFFFC03D),
                    ),
                    child: IconButton(
                        icon: Icon(
                          Icons.navigation_outlined,
                          color: Color(0xFF303250),
                        ),
                        onPressed: () {
                          MapUtils.openMap(widget.address);
                        }),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            Container(
                child: RatingBar.builder(
              initialRating: 3.0,
              itemBuilder: (context, _) {
                return Icon(
                  Icons.star,
                  color: Color(0xFFF79E1B),
                );
              },
              itemCount: 5,
              allowHalfRating: true,
              direction: Axis.horizontal,
              minRating: 1.0,
              maxRating: 5.0,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              onRatingUpdate: (rating) {
                print(rating);
                changedRating = true;
                ratingValue = rating;
              },
            )),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
