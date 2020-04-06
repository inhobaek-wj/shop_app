import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/secret.dart';
import '../models/http_exception.dart';

class Auth with ChangeNotifier {

  String _token;
  String _userId;
  DateTime _expiryDate;

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
}