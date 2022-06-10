import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';

import '../screens/modal_examinar.dart';

class ModalHomeController extends GetxController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String _bodega = "";
  String _producto = "";
  String _codProducto = "";
  String _grupo = "";
  String _linea = "";
  String _saldo = "";

  String get bodega => _bodega;
  set bodega(String value) {
    _bodega = value;
    update();
  }

  String get producto => _producto;
  set producto(String value) {
    _producto = value;
  }

  String get codProducto => _codProducto;
  set codProducto(String value) {
    _codProducto = value;
  }

  String get grupo => _grupo;
  set grupo(String value) {
    _grupo = value;
    update();
  }

  String get linea => _linea;
  set linea(String value) {
    _linea = value;
    update();
  }

  String get saldo => _saldo;
  set saldo(String value) {
    _saldo = value;
    update();
  }

  void borrarCodProducto() {
    _codProducto = "";
    update();
  }

  void borrarProducto() {
    _producto = "";
    update();
  }

  void limpiar() {
    this._bodega = "";
    this._producto = "";
    this._codProducto = "";
    this._grupo = "";
    this._linea = "";
    this._saldo = "";

    update();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    update();
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  void showModalDataBodega(String endpoint) async {
    final result =
        await Get.to<String>(const ModalExaminar(), arguments: endpoint);

    if (result != null) {
      print(result);
      if (endpoint == "bodega") {
        _bodega = result;
        update();
      }
      if (endpoint == "linea") {
        _linea = result;
        update();
      }
      if (endpoint == "grupo") {
        _grupo = result;
        update();
      }
    }
  }
}
