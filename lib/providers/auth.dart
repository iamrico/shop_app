import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http_exception.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }

    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> signup(String email, String password) async {
    const api_key = 'AIzaSyB-8M07E0MANRZZ6LCa4se-Px_sX_Qmk6A';

    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$api_key';
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      notifyListeners();
      autoLogout();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({'token': _token, 'userId': _userId, 'expiryDate': _expiryDate.toIso8601String()});
      prefs.setString('userData', userData);
    } catch (e) {
      throw e;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }

    final extractedUserData = json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if(expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;

    notifyListeners();
    autoLogout();
    return true;
  } 

  Future<void> login(String email, String password) async {
    const api_key = 'AIzaSyB-8M07E0MANRZZ6LCa4se-Px_sX_Qmk6A';
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$api_key';

    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      notifyListeners();
      autoLogout();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({'token': _token, 'userId': _userId, 'expiryDate': _expiryDate.toIso8601String()});
      prefs.setString('userData', userData);
    } catch (e) {
      throw e;
    }
  }

  Future<void> logout() async  {
    _token = null;
    _userId = null;
    _expiryDate = null;

    if(_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void autoLogout() {

    if(_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry =_expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
