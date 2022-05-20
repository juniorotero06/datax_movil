import 'package:flutter/material.dart';

class SearchBalanceFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String bodega = "";
  String producto = "";
  String codProducto = "";
  String grupo = "";
  String linea = "";
  String saldo = "";

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
