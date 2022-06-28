import 'package:datax_movil/models/models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuxiliarServices extends ChangeNotifier {
  //final String _baseUrl = "10.0.3.2:3001";
  final String _baseUrl = "api-atxel.herokuapp.com";
  List<Bodegas> onDisplayBodegas = [];
  List<Lineas> onDisplayLineas = [];
  List<Grupos> onDisplayGrupo = [];
  late CuentasxCobrar onDisplayCuentasxCobrar;
  late CuentasxPagar onDisplayCuentasxPagar;
  AuxiliarServices() {
    getBodegas;
    getLineas;
    getGrupos;
    getCuentas;
  }

  getBodegas(String token) async {
    final url = Uri.https(_baseUrl, "/api/aux/bodegas");

    final resp = await http.get(url, headers: {
      "auth-token": token,
    });

    final getBodegasResponse = GetBodegasResponse.fromJson(resp.body);
    onDisplayBodegas = getBodegasResponse.results;
    notifyListeners();
  }

  getLineas(String token) async {
    final url = Uri.https(_baseUrl, "/api/aux/lineas");

    final resp = await http.get(url, headers: {
      "auth-token": token,
    });

    final getLineasResponse = GetLineasResponse.fromJson(resp.body);
    onDisplayLineas = getLineasResponse.results;
    notifyListeners();
  }

  getGrupos(String token) async {
    final url = Uri.https(_baseUrl, "/api/aux/grupo");

    final resp = await http.get(url, headers: {
      "auth-token": token,
    });

    final getGruposResponse = GetGruposResponse.fromJson(resp.body);
    onDisplayGrupo = getGruposResponse.results;
    notifyListeners();
  }

  getCuentas(String token) async {
    final url = Uri.https(_baseUrl, "/api/aux/cuentas");

    final resp = await http.get(url, headers: {
      "auth-token": token,
    });

    final getCuentasResponse = GetCuentasResponse.fromJson(resp.body);
    onDisplayCuentasxCobrar = getCuentasResponse.cuentasxCobrar;
    onDisplayCuentasxPagar = getCuentasResponse.cuentasxPagar;
    notifyListeners();
  }
}
