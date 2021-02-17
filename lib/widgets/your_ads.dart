
//import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

//import 'package:advMe/widgets/category_item.dart';
import 'package:advMe/widgets/orders_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class YourAds extends StatefulWidget {
  @override
  _YourAdsState createState() => _YourAdsState();
}

class _YourAdsState extends State<YourAds> {
  @override
  Widget build(BuildContext context) {
    var userId = FirebaseAuth.instance.currentUser.uid;
    //final transitionType = ContainerTransitionType.fade;
    
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Color(0xFF171923),
      ),
      child: Stack(
        children: [
          Center(
            child: RotatedBox(
              quarterTurns: 1,
              child: Text(
                'advMe',
                style: GoogleFonts.ubuntu(
                  color: Color(0x40C31331),
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
                    child: CircularProgressIndicator(),
                  );
                }

                print(orderSnapshot.data.docs.length);
                return ListView.builder(
                  reverse: false,
                  itemCount: orderSnapshot.data.docs.length,
                  itemBuilder: (ctx, index) {
                    DocumentSnapshot userData = orderSnapshot.data.docs[index];

                    return OrdersItem(
                        description: userData.data()['title'],
                        id: userData.id,
                        imageUrl: userData.data()['imageUrl'],
                        isFavorite: false,
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
