import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  Future<void> signup (String email, String password) async {
    const api_key = 'AIzaSyB-8M07E0MANRZZ6LCa4se-Px_sX_Qmk6A';

    const url = 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$api_key';

    final response = await http.post(url,body: json.encode({
      'email': email,
      'password': password,
      'returnSecureToken': true,
    }));

    print(json.decode(response.body));

  }

  Future<void> login (String email, String password) async {
    const api_key = 'AIzaSyB-8M07E0MANRZZ6LCa4se-Px_sX_Qmk6A';
    const url = 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$api_key';

    final response = await http.post(url, body: json.encode({
      'email': email,
      'password': password,
      'returnSecureToken': true,
    }));

    print(json.decode(response.body));
  }
}