import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavorite(String token, String userId) async {
    final url =
        'https://shop-1d2d0.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';

    isFavorite = !isFavorite;
    notifyListeners();

    try {
      await http.put(url, body: json.encode(isFavorite));
    } catch (e) {
    }
  }
}
