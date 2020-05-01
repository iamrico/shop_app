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

  Future<void> toggleFavorite(String token) async {
    final url = 'https://shop-1d2d0.firebaseio.com/products/$id.json?auth=$token';

    isFavorite = !isFavorite;
    notifyListeners();
    
    try {
      await http.patch(url, body: json.encode({
        'isFavorite': isFavorite
      }));
    } catch(e) {
      print(e.toString());
    }
  }
}
