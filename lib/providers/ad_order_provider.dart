import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

Future<void> _addPost(DateTime date, String, description, String url, File _pickedImage ) async {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    var rng = new Random();
    var random = rng.nextInt(100);

    final ref = FirebaseStorage.instance
        .ref()
        .child('posts')
        .child(firebaseUser.uid + '.jpg');

    await ref.putFile(_pickedImage);
    

    final url = await ref.getDownloadURL();

    FirebaseFirestore.instance.collection('posts').doc().set({
      'id': '$random',
      'description': description,
      'imageUrl': url,
      'isFavorite': true,
      'userId' : firebaseUser,
    });
    //description.clear();
    
    print('Adding photo...');

    //Navigator.of(context).pop();
  }