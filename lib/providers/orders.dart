import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:advMe/providers/order.dart';

class Orders with ChangeNotifier {
  List<Order> _items = [
    
  ];

  List<Order> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items];
  }

  Future<void> fetchAndSetProducts() async {
    var uId = FirebaseAuth.instance.currentUser.uid;
    final List<Order> loadedProducts = [];
   await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection("user_orders")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((prodData) {
        loadedProducts.add(
          Order(
            userId: prodData.data()['userId'],
            description: prodData.data()['description'],
            id: prodData.data()['id'],
            title: prodData.data()['title'],
            imageUrl: prodData.data()['imageUrl'],
            isFavorite: false,
            price: prodData.data()['price'],
            phone: prodData.data()['phone'],
            website: prodData.data()['website'],
            address: prodData.data()['address'],
            date: prodData.data()['date'],
          ),
        );
        //print(prodData.data()['title']);
      });
         
         print('Ilość załadowanych ogłoszeń providerem: ' +items.length.toString());

    });

    _items = loadedProducts;
    notifyListeners();
  }

  Future<void> addOrder(
    Order order,
  ) async {
    try {
      var uid = FirebaseAuth.instance.currentUser.uid;
      await FirebaseFirestore.instance
          .collection('allAds')
          .add({
        'Added on ': order.date,
        'title': order.title,
        'description': order.description,
        'imageUrl': order.imageUrl,
        'isFavorite': true,
        'userId': uid,
        'price': order.price,
        'phone': order.phone,
        'website': order.website,
        'address': order.address,
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection("user_orders")
          .add({
        'Added on ': order.date,
        'title': order.title,
        'description': order.description,
        'imageUrl': order.imageUrl,
        'isFavorite': true,
        'userId': uid,
        'price': order.price,
        'phone': order.phone,
        'website': order.website,
        'address': order.address,
      });
      final newProduct = Order(
        userId: order.userId,
        id: order.id,
        title: order.title,
        description: order.description,
        price: order.price,
        imageUrl: order.imageUrl,
        date: order.date,
        phone: order.phone,
        website: order.website,
        address: order.address,
        isFavorite: false,
      );
      _items.add(newProduct);
      // _items.insert(0, newProduct); // at the start of the list
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Order newProduct) async {
    // final prodIndex = _items.indexWhere((prod) => prod.id == id);
    // if (prodIndex >= 0) {
    //   final url =
    //       'https://flutter-update-fb73c.firebaseio.com/products/$id.json';
    //   await http.patch(url,
    //       body: json.encode({
    //         'title': newProduct.title,
    //         'description': newProduct.description,
    //         'imageUrl': newProduct.imageUrl,
    //         'price': newProduct.price
    //       }));
    //   _items[prodIndex] = newProduct;
    //   notifyListeners();
    // } else {
    //   print('...');
    // }
  }

  Future<void> deleteProduct(String id, String title) async {
    var firebaseUser = FirebaseAuth.instance.currentUser.uid;
    String itemToDelete = title + '.jpg';

    var storageReferance = FirebaseStorage.instance.ref();
    storageReferance
        .child('allAds/$firebaseUser/$itemToDelete')
        .delete()
        .then((_) {
      print("Deleting from Storage success!");
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser)
        .collection("user_orders")
        .doc(id)
        .delete()
        .then((_) {
      print("Deleting from Firebase success!");
    });

    final existingOrderIndex = _items.indexWhere((ord) => ord.id == id);
    //var existingOrder = _items[existingOrderIndex];
    _items.removeAt(existingOrderIndex);
    notifyListeners();

    // if (response.statusCode >= 400) {
    //   _items.insert(existingOrderIndex, existingOrder);
    //   notifyListeners();
    // }
    //TODO handle error when deleting failed.
    //existingOrder = null;
  }
}
