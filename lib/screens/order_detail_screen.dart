import 'package:advMe/helpers/location_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:advMe/helpers/google_map_aplication_helper.dart';
import 'package:provider/provider.dart';
import 'package:advMe/providers/settings.dart';
import 'package:advMe/helpers/string_extenstion.dart';

class OrderDetailScreen extends StatefulWidget {
  static const routeName = '/orderl-detail';
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

  OrderDetailScreen({
    this.id,
    this.title,
    this.description,
    this.isFavorite,
    this.imageUrl,
    this.price,
    this.phone,
    this.website,
    this.address,
    this.isYourAds,
  });

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  String _previewImageUrl;

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

//TODO make sure that in all orders user can't delete order!!!

  Future<void> _deleteUserOrder(String id, String title) async {
    var firebaseUser = FirebaseAuth.instance.currentUser.uid;
    String itemToDelete = widget.title + '.jpg';

    var storageReferance = FirebaseStorage.instance.ref();
    storageReferance
        .child('allAds/$firebaseUser/$itemToDelete')
        .delete()
        .then((_) {
      print("Deleting from Storage success!");
    });

    //     await FirebaseStorage.instance.refFromURL(widget.imageUrl).delete().then((_) {
    //   print("Deleting from Storage success!");
    // });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser)
        .collection("user_orders")
        .doc(widget.id)
        .delete()
        .then((_) {
      print("Deleting from Firebase success!");
    });

    Navigator.of(context).pop();
    Navigator.of(context).pop();

    // TODO: ADD ScaffoldMessneger in next stable flutter release
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(
    //     content: Text('A SnackBar has been shown.'),
    //   ),
    // );
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
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    final staticMapImageUrl =
        LocationHelper.generateLocationPreviewImagebyAddress(widget.address);

    _previewImageUrl = staticMapImageUrl;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsUser>(context);
    return Scaffold(
      
      // appBar: AppBar(
      //     iconTheme: IconThemeData(
      //       color: Color(0xFFF79E1B),
      //     ),
      //     backgroundColor: Color(0xFF171923),
      //     title: Text(widget.title),
      //     actions: [
      //       IconButton(
      //           icon: Icon(Icons.delete),
      //           onPressed: () {
      //             _showMyDialog();
      //           }),
      //     ]),
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
                          // boxShadow: [
                          //   BoxShadow(
                          //       color: Color(0x40F79E1B),
                          //       offset: Offset(2.0, 2.0),
                          //       blurRadius: 5.0,
                          //       spreadRadius: 1.0),
                          //   BoxShadow(
                          //       color: Color(0x40F79E1B),
                          //       offset: Offset(-2.0, -2.0),
                          //       blurRadius: 5.0,
                          //       spreadRadius: 1.0),
                          // ],
                          color: settings.isDark
                              ? Color(0x40303250)
                              : Color(0xFF0D276B))),
                  //Color(0x40303250))),
                ),
              ),
              if(widget.isYourAds)
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
              child: Swiper(
                itemCount: 3,
                itemWidth: MediaQuery.of(context).size.width - 2 * 64,
                layout: SwiperLayout.STACK,
                pagination: SwiperPagination(
                    builder: DotSwiperPaginationBuilder(
                  activeSize: 10,
                  space: 0,
                )),
                itemBuilder: (_, index) {
                  //return InkWell(onTap: () {});

                  return Stack(children: [
                    Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        //color: Colors.white,
                        child:
                            //Container(
                            //   decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(32),
                            //   ),
                            //   child:
                            //FittedBox(child:
                            Image.network(widget.imageUrl)),
                  ]);
                },
              ),
            ),
            //Image.network(widget.imageUrl)),
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
          ],
        ),
      ),
    );
  }
}
