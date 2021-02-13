import 'package:flutter/material.dart';

//import 'package:advMe/widgets/category_item.dart';
import 'package:advMe/widgets/orders_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class YourAds extends StatefulWidget {
  @override
  _YourAdsState createState() => _YourAdsState();
}

class _YourAdsState extends State<YourAds> {
  @override
  Widget build(BuildContext context) {
      var userId = FirebaseAuth.instance.currentUser.uid;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color(0xFFF79E1B),
        ),
        backgroundColor: Color(0xFF171923),
        title: const Text(
          'Kategorie',
          style: TextStyle(color: Color(0xFFF79E1B)),
        ),
      ),
      backgroundColor: Color(0xFF171923),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('user_orders')
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> orderSnapshot) {
          if (orderSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          print(orderSnapshot.data.docs.length);
          return ListView.builder(
              reverse: true,
              itemCount: orderSnapshot.data.docs.length,
              itemBuilder: (ctx, index) {
                DocumentSnapshot userData = orderSnapshot.data.docs[index];

                return OrdersItem(description: userData.data()['title'], id: null, imageUrl: userData.data()['imageUrl'], isFavorite: false,);
              });
        },
      ),
    );
  }
}