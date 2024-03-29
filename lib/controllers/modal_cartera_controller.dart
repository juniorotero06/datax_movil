import 'package:get/state_manager.dart';
import 'package:flutter/material.dart';

class ModalCarteraController extends GetxController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String _codTercero = "";
  String _nomTercero = "";
  bool cXCEnabled = false;
  bool cxPEnabled = false;
  String tipo = "";
  String clase = "";
  String cuenta = "";
  dynamic vrSaldo;
  bool isCXPC = false;

  String get codTercero => _codTercero;
  set codTercero(String value) {
    _codTercero = value;
  }

  String get nomTercero => _nomTercero;
  set nomTercero(String value) {
    _nomTercero = value;
  }

  void isCXPCChange() {
    if (cXCEnabled && cxPEnabled) {
      isCXPC = true;
      print("isCXPC: $isCXPC");
    } else {
      isCXPC = false;
    }
    update();
  }

  void pressCheckCXC(bool value) {
    cXCEnabled = value;
    update();
  }

  void pressCheckCXP(bool value) {
    cxPEnabled = value;
    update();
  }

  void borrarCodTercero() {
    _codTercero = "";
    update();
  }

  void borrarNomTercero() {
    _nomTercero = "";
    update();
  }

  void limpiar() {
    cXCEnabled = false;
    cxPEnabled = false;
    cuenta = "";
    _codTercero = "";
    _nomTercero = "";
    update();
  }

  void selectAllOptions() {
    cXCEnabled = true;
    cxPEnabled = true;
    update();
  }
}
