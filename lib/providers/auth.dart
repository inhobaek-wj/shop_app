import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/secret.dart';

class Auth with ChangeNotifier {
  static const serverUrl = 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=';

  String _token;
  String _userId;
  DateTime _expiryDate;

  Future<void> signup(String email, String password) async {
    const url = serverUrl + Secret.apiKey;

    final response = await http.post(
      url,
      body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
      }),
    );
  }

}
