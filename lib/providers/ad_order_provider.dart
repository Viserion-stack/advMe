import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';


Future<void> addPost(
    DateTime date, String title, String description, File _pickedImage) async {


  
  var uid = FirebaseAuth.instance.currentUser.uid;

  print('FB USER: ' + uid.toString());

  // var rng = new Random();
  // var random = rng.nextInt(100);

  final ref = FirebaseStorage.instance
      .ref()
      .child('allAds').child(uid)
      .child(title + '.jpg');

  await ref.putFile(_pickedImage);

  final url = await ref.getDownloadURL();

 await FirebaseFirestore.instance
      .collection('users')
      .doc(uid).collection("user_orders")
      .add({
    'Added on ': date,
    'title': title,
    'description': description,
    'imageUrl': url,
    'isFavorite': true,
    'userId': uid,
  });
  //description.clear();

  print('Adding photo...');

  //Navigator.of(context).pop();
}
