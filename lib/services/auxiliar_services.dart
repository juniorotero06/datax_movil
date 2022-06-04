import 'package:datax_movil/models/models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuxiliarServices extends ChangeNotifier {
  final String _baseUrl = "10.0.3.2:3001";
  List<Bodegas> onDisplayBodegas = [];
  List<Lineas> onDisplayLineas = [];
  List<Grupos> onDisplayGrupo = [];
  AuxiliarServices() {
    getBodegas;
    getLineas;
    getGrupos;
  }

  getBodegas(String token) async {
    final url = Uri.http(_baseUrl, "/api/aux/bodegas");

    final resp = await http.get(url, headers: {
      "auth-token": token,
    });

    final getBodegasResponse = GetBodegasResponse.fromJson(resp.body);
    onDisplayBodegas = getBodegasResponse.results;
    notifyListeners();
  }

  getLineas(String token) async {
    final url = Uri.http(_baseUrl, "/api/aux/lineas");

    final resp = await http.get(url, headers: {
      "auth-token": token,
    });

    final getLineasResponse = GetLineasResponse.fromJson(resp.body);
    onDisplayLineas = getLineasResponse.results;
    notifyListeners();
  }

  getGrupos(String token) async {
    final url = Uri.http(_baseUrl, "/api/aux/grupo");

    final resp = await http.get(url, headers: {
      "auth-token": token,
    });

    final getGruposResponse = GetGruposResponse.fromJson(resp.body);
    onDisplayGrupo = getGruposResponse.results;
    notifyListeners();
  }
}
