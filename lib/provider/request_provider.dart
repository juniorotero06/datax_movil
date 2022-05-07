import 'package:flutter/material.dart';

class RequestProvider extends ChangeNotifier {
  String _endpoint = "";
  String _body = "";

  String get endpoint => _endpoint;
  set endpoint(String value) {
    _endpoint = value;
    notifyListeners();
  }

  String get body => _body;
  set body(String value) {
    _body = value;
    notifyListeners();
  }
}
