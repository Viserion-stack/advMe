import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<void> addPost(
    DateTime date, String title, String description, File _pickedImage) async {
  var firebaseUser = FirebaseAuth.instance.currentUser.uid;

  print('FB USER: ' + firebaseUser.toString());

  // var rng = new Random();
  // var random = rng.nextInt(100);

  final ref = FirebaseStorage.instance
      .ref()
      .child('allAds')
      .child(firebaseUser + '.jpg');

  await ref.putFile(_pickedImage);

  final url = await ref.getDownloadURL();

  FirebaseFirestore.instance
      .collection('allAds')
      .doc(firebaseUser)
      .collection(title)
      .doc(title)
      .set({
    'Added on ': date,
    'title': title,
    'description': description,
    'imageUrl': url,
    'isFavorite': true,
    'userId': firebaseUser,
  });
  //description.clear();

  print('Adding photo...');

  //Navigator.of(context).pop();
}
