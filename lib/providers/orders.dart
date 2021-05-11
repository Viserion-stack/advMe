import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:advMe/providers/order.dart';

class Orders with ChangeNotifier {
  List<Order> _items = [];
  List itemFavorite = [];

  var zmienna;

  List<Order> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }

    return [..._items];
  }

  List<void> itemstitles() {
    // if (_showFavoritesOnly) {
    //   return _items.where((orderItem) => orderItem.isFavorite).toList();
    // }

    final ads = [];
    for (int i = 0; i < _items.length; i++) {
      ads.add(_items[i].title);
    }
    print('AAA');
    print(ads);
    print('BBB');
    return ads;
  }

  Future<void> fetchFavorite() async {
    var uid = FirebaseAuth.instance.currentUser.uid;
    final List loadedFavorites = [];
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('favorite')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((prodData) {
        loadedFavorites.add(
          prodData.data()['Id'],
        );
      });
    });
    itemFavorite = loadedFavorites;
    print('pobranych favorites ' + itemFavorite.length.toString());
    print('lista' + itemFavorite.toList().toString());
    notifyListeners();
  }

  Future<void> fetchAndSetProducts() async {
    bool favoriteState = false;
    //var uId = FirebaseAuth.instance.currentUser.uid;
    final List<Order> loadedProducts = [];

    await FirebaseFirestore.instance
        .collection('allAds')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((prodData) {
        print('favorite provider' + itemFavorite.toString());
        for (int i = 0; i < itemFavorite.length; i++) {
          if (prodData.id.toString() == itemFavorite[i].toString()) {
            favoriteState = true;
            break;
          } else
            favoriteState = false;
        }
        loadedProducts.add(
          Order(
            userId: prodData.data()['userId'],
            description: prodData.data()['description'],
            id: prodData.id,
            title: prodData.data()['title'],
            imageUrl1: prodData.data()['imageUrl1'],
            imageUrl2: prodData.data()['imageUrl2'],
            imageUrl3: prodData.data()['imageUrl3'],
            isFavorite: favoriteState,
            price: prodData.data()['price'],
            phone: prodData.data()['phone'],
            website: prodData.data()['website'],
            address: prodData.data()['address'],
            date: prodData.data()['date'],
            category: prodData.data()['category'],
            rating: prodData.data()['rating'],
            countRating: prodData.data()['countRating'],
            sumRating: prodData.data()['sumRating'],
          ),
        );
        //print(prodData.data()['title']);
      });

      print(
          'Ilość załadowanych ogłoszeń providerem: ' + items.length.toString());
    });

    _items = loadedProducts;
    notifyListeners();
  }

  Future<void> addOrder(
    Order order,
  ) async {
    try {
      var uid = FirebaseAuth.instance.currentUser.uid;
      await FirebaseFirestore.instance.collection('allAds').add({
        'Added on ': order.date,
        'id': order.id,
        'title': order.title,
        'description': order.description,
        'imageUrl1': order.imageUrl1,
        'imageUrl2': order.imageUrl2,
        'imageUrl3': order.imageUrl3,
        'isFavorite': true,
        'userId': uid,
        'price': order.price,
        'phone': order.phone,
        'website': order.website,
        'address': order.address,
        'category': order.category,
        'rating': 3.5.toDouble(),
        'countRating': 0.toInt(),
        'sumRating': 3.5.toDouble(),
      }).then((value) {
        zmienna = value.id;
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection("user_orders")
          .doc(zmienna)
          .set({
        'id': zmienna,
        'Added on ': order.date,
        'title': order.title,
        'description': order.description,
        'imageUrl1': order.imageUrl1,
        'imageUrl2': order.imageUrl2,
        'imageUrl3': order.imageUrl3,
        'isFavorite': true,
        'userId': uid,
        'price': order.price,
        'phone': order.phone,
        'website': order.website,
        'address': order.address,
        'category': order.category,
        'rating': 3.5.toDouble(),
        'countRating': 0.toInt(),
        'sumRating': 3.5.toDouble(),
      });
      final newProduct = Order(
        userId: order.userId,
        id: zmienna,
        title: order.title,
        description: order.description,
        price: order.price,
        imageUrl1: order.imageUrl1,
        imageUrl2: order.imageUrl2,
        imageUrl3: order.imageUrl3,
        date: order.date,
        phone: order.phone,
        website: order.website,
        address: order.address,
        category: order.category,
        rating: order.rating,
        countRating: order.countRating,
        sumRating: order.sumRating,
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
    // ignore: todo
    //TODO handle error when deleting failed.
    //existingOrder = null;
  }
}
