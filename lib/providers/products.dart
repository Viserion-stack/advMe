import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];
  // var _showFavoritesOnly = false;

  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }
  //final uId = FirebaseAuth.instance.currentUser.uid;

  Future<void> fetchAndSetProducts() async {

      //CollectionReference extractedData = FirebaseFirestore.instance.collection('allAds');

      //print(extractedData.doc(uId).get());

    
    // const url = 'https://flutter-update-fb73c.firebaseio.com/products.json';
    // try {
    //   final response = await http.get(url);
    //   final extractedData = FirebaseFirestore.instance.collection('allAds').doc(uId).collection(uId).snapshots() as Map<String, dynamic>;
    //   if (extractedData == null) {
    //     return;
    //   }
    //   final List<Product> loadedProducts = [];
    //   extractedData.forEach((prodId, prodData) {
    //     loadedProducts.add(Product(
    //       id: prodId,
    //       title: prodData['title'],
    //       description: prodData['description'],
    //       price: prodData['price'],
    //       isFavorite: prodData['isFavorite'],
    //       imageUrl: prodData['imageUrl'],
    //     ));
    //   });
    //   _items = loadedProducts;
    //   notifyListeners();
    // } catch (error) {
    //   throw (error);
    // }
  }

  Future<void> addProduct(Product product, File _pickedImage) async {
    try {

      final ref = FirebaseStorage.instance
          .ref()
          .child('allAds')
          .child(product.userId + '.jpg');

      await ref.putFile(_pickedImage);

      final url = await ref.getDownloadURL();

      FirebaseFirestore.instance
          .collection('allAds')
          .doc(product.userId)
          .collection(product.title)
          .doc(product.title)
          .set({
        'Added on ': product.date,
        'title': product.title,
        'description': product.description,
        'imageUrl': url,
        'isFavorite': true,
        'userId': product.userId,
        'id': product.id
      });
      final newProduct = Product(
        userId: product.userId,
        id: product.id,
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        date: product.date,
      );
      _items.add(newProduct);
      // _items.insert(0, newProduct); // at the start of the list
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://flutter-update-fb73c.firebaseio.com/products/$id.json';
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = 'https://flutter-update-fb73c.firebaseio.com/products/$id.json';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw FirebaseException(plugin: null, message: null);
    }
    existingProduct = null;
  }
}
