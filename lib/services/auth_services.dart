import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthServices extends ChangeNotifier {
  //final String _url = "http://localhost:3001/api/auth/user_login";
  final String _baseUrl = "10.0.3.2:3001";

  Future<String?> loginUser(String email, String password) async {
    final Map<String, dynamic> authData = {
      "email": email,
      "password": password
    };

    final url = Uri.http(_baseUrl, "/api/auth/user_login");
    //final url = Uri.https(_baseUrl, "/api/auth/user_login");

    final resp = await http.post(url, body: authData);
    final Map<String, dynamic> decodeResp = json.decode(resp.body);

    if (decodeResp.containsKey("data")) {
      return decodeResp.toString();
    } else {
      return decodeResp["error"];
    }
  }
}
