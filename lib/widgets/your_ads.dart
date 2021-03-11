
//import 'package:animations/animations.dart';
import 'package:advMe/providers/settings.dart';
import 'package:flutter/material.dart';

//import 'package:advMe/widgets/category_item.dart';
import 'package:advMe/widgets/orders_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class YourAds extends StatefulWidget {
  @override
  _YourAdsState createState() => _YourAdsState();
}

class _YourAdsState extends State<YourAds> {
  @override
  Widget build(BuildContext context) {
    var userId = FirebaseAuth.instance.currentUser.uid;
    //final transitionType = ContainerTransitionType.fade;
    final settings = Provider.of<SettingsUser>(context);
    bool isYourAds = true;
    
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: settings.isDark ? Color(0xFF171923) : Color(0xFFE9ECF5),
      ),
      child: Stack(
        children: [
          Center(
            child: RotatedBox(
              quarterTurns: 3,
              child: Text(
                'advMe',
                style: GoogleFonts.ubuntu(
                  color: settings.isDark ? Color(0x40C31331): Color(0x78FFC03D),
                  fontSize: 140,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .collection('user_orders')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> orderSnapshot) {
                if (orderSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitWave(color: Color(0xFFF79E1B),)
                    //CircularProgressIndicator(),
                  );
                }

                print('Ilość załadowanych ogłoszeń streambuilderem '+ orderSnapshot.data.docs.length.toString());
                return ListView.builder(
                  cacheExtent: 1000,
                  reverse: false,
                  itemCount: orderSnapshot.data.docs.length,
                  itemBuilder: (ctx, index) {
                    DocumentSnapshot userData = orderSnapshot.data.docs[index];

                    return OrdersItem(
                        description: userData.data()['description'],
                        id: userData.id,
                        title: userData.data()['title'],
                        imageUrl1: userData.data()['imageUrl1'],
                        imageUrl2: userData.data()['imageUrl2'],
                        imageUrl3: userData.data()['imageUrl3'],
                        isFavorite: false,
                        price: userData.data()['price'],
                        phone: userData.data()['phone'],
                        website: userData.data()['website'],
                        address: userData.data()['address'],
                        category: userData.data()['address'],
                        isYourAds: isYourAds,
                      );
                    
                    
                    
                    
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
