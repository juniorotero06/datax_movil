import 'package:flutter/material.dart';

class AddUserFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String name = "";
  String lastname = "";
  String email = "";
  String password = "";
  String phone = "";
  String licenseId = "";
  String rol = "User";

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
