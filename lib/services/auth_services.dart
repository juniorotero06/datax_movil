import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthServices extends ChangeNotifier {
  //final String _url = "http://localhost:3001/api/auth/user_login";
  final String _baseUrl = "10.0.3.2:3001";

  final storage = const FlutterSecureStorage();

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
      await storage.write(
          key: 'auth-token', value: decodeResp["data"]["token"]);
      return null;
    } else {
      return decodeResp["error"];
    }
  }

  Future logout() async {
    await storage.delete(key: 'auth-token');
    return;
  }

  Future<String> readToken() async {
    return await storage.read(key: 'auth-token') ?? "";
  }

  Future<String?> registerData(
      String name, String lastname, String email, String password) async {
    final Map<String, dynamic> registerInfo = {
      "name": name,
      "lastname": lastname,
      "email": email,
      "password": password
    };

    final url = Uri.http(_baseUrl, "/api/auth/regiter_data");

    final resp = await http.post(url, body: registerInfo);
    final Map<String, dynamic> decodeResp = json.decode(resp.body);

    if (decodeResp.containsKey("data")) {
      return null;
    } else {
      return decodeResp["error"];
    }
  }

  Future<String?> licenseData(
      String companyName,
      String address,
      String email,
      String phone,
      String host,
      String bdUser,
      String bdName,
      String bdPass,
      String registerName,
      String registerLastname,
      String registerEmail,
      String registerPassword) async {
    final Map<String, dynamic> licenseInfo = {
      "companyName": companyName,
      "address": address,
      "email": email,
      "phone": phone,
      "host": host,
      "bdUser": bdUser,
      "bdName": bdName,
      "bdPass": bdPass,
      "registerName": registerName,
      "registerLastname": registerLastname,
      "registerEmail": registerEmail,
      "registerPassword": registerPassword
    };

    final url = Uri.http(_baseUrl, "/api/auth/license_data");

    final resp = await http.post(url, body: licenseInfo);

    final Map<String, dynamic> decodeResp = json.decode(resp.body);

    if (decodeResp.containsKey("data")) {
      return null;
    } else {
      return decodeResp["error"];
    }
  }
}
