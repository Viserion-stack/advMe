import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Order with ChangeNotifier {
  final String userId;
  final String id;
  final String title;
  final String description;
  final String price;
  final String imageUrl1;
  final String imageUrl2;
  final String imageUrl3;
  final DateTime date;
  final String phone;
  final String website;
  final String address;
  final String category;
  bool isFavorite;

  Order({
    @required this.userId,
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl1,
    @required this.imageUrl2,
    @required this.imageUrl3,
    @required this.date,
    @required this.phone,
    @required this.website,
    @required this.address,
    @required this.category,
    this.isFavorite = false,
  });

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus() async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = 'https://flutter-update-fb73c.firebaseio.com/products/$id.json';
    try {
      final response = await http.patch(
        url,
        body: json.encode({
          'isFavorite': isFavorite,
        }),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
