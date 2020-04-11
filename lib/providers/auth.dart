import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/secret.dart';
import '../models/http_exception.dart';

class Auth with ChangeNotifier {

  String _token;
  String _userId;
  DateTime _expiryDate;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token{
    if (_expiryDate != null
      && _expiryDate.isAfter(DateTime.now())
      && _token != null) {
      return _token;
    }

    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(String email, String password, String endPoint) async {
    final url =
    'https://identitytoolkit.googleapis.com/v1/accounts:$endPoint?key=${Secret.apiKey}';

    print(url);
    try {
      final response = await http.post(
        url,
        body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
        }),
      );

      final responseBody = json.decode(response.body);
      if (responseBody['error'] != null) {
        throw HttpException(responseBody['error']['message']);
      }

      _token = responseBody['idToken'];
      _userId = responseBody['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseBody['expiresIn'],
          )
      ));

      _autoLogout();

      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
          'userId': _userId,
          'token': _token,
          'expiryDate': _expiryDate.toIso8601String()
      });
      prefs.setString('userData', userData);

    } catch(error){
      throw error;
    }

  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }

    final extracedUserData = json.decode(prefs.getString('userData')) as Map<String,Object>;
    final expiryData = DateTime.parse(extracedUserData['expiryDate']);

    if (expiryData.isBefore(DateTime.now())){
      return false;
    }

    _token = extracedUserData['token'];
    _userId = extracedUserData['userId'];
    _expiryDate = expiryData;

    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async{
    _token = null;
    _userId = null;
    _expiryDate = null;

    if (_authTimer != null){
      _authTimer.cancel();
      _authTimer = null;
    }

    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogout(){
    if (_authTimer != null){
      _authTimer.cancel();
    }

    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
