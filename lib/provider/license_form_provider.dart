import 'package:flutter/material.dart';

class LicenseFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String companyName = "";
  String address = "";
  String email = "";
  String phone = "";
  String host = "";
  String bdUser = "";
  String bdName = "";
  String bdPass = "";

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
