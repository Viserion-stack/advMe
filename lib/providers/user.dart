import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class User with ChangeNotifier {
  String userId;
  String userName;
  String email;
  bool isPremium;
  String imageUrl;
  DateTime createdAt;
  bool isDark;
  bool isNotify;
  int screenIndex=0;

  User({
    this.userId,
    this.userName,
    this.email,
    this.isPremium,
    this.imageUrl,
    this.createdAt,
    this.isDark,
    this.screenIndex,
  });


   Future<void> setScreenIndex(int index) async{
    screenIndex = index;
    notifyListeners();
   
    
  }

int getCurrentIndex() {
    return screenIndex;
  }

  Future<void> getUserData() async {

    try {
      final uid = FirebaseAuth.instance.currentUser.uid;
      final DocumentReference document =
          FirebaseFirestore.instance.collection('users').doc(uid);
      await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
        userId = uid;
        userName = snapshot.data()['username'];
        email = snapshot.data()['email'];
        isPremium = snapshot.data()['isPremium'];
        imageUrl = snapshot.data()['imageUrl'];
        createdAt = snapshot.data()['createdAt'];
        isDark = snapshot.data()['isDark'];

        //notifyListeners();
      });
    } catch (error) {
      print(error);
      throw error;
    }
  }
   void setValues(bool newFav, bool newNotif) {
    isDark = newFav;
    isNotify = newNotif;
    notifyListeners();
  }
}
