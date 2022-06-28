import 'package:datax_movil/models/models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BalanceServices extends ChangeNotifier {
  //final String _baseUrl = "10.0.3.2:3001";
  final String _baseUrl = "api-atxel.herokuapp.com";
  List<SaldosWithGrupo> onDisplaySaldosWithGrupo = [];
  List<Cartera> onDisplayCartera = [];
  List<CarteraCXPC> onDisplayCarteraCXPX = [];
  List<DetailsCartera> onDisplayDetailsCartera = [];
  int totalData = 0, totalPages = 0;

  BalanceServices() {
    getSaldosByFilters;
    getCartera;
    getDetail_CxPC;
  }

  getSaldosByFilters(
      String query, String page, String size, String token) async {
    final Map<String, String> queryParams = {"page": page, "size": size};

    final Map<String, String> bodyQuery = {"query": query};

    final url = Uri.https(_baseUrl, "/api/balance_filters", queryParams);

    final resp = await http.post(url, body: bodyQuery, headers: {
      "auth-token": token,
    });

    final getSaldoswithGrupo = GetFiltersResponse.fromJson(resp.body);
    totalData = getSaldoswithGrupo.results.totalData;
    totalPages = getSaldoswithGrupo.results.totalPages;
    onDisplaySaldosWithGrupo = getSaldoswithGrupo.results.content;
    notifyListeners();
  }

  getCartera(String query, String token, bool isCXPX) async {
    final Map<String, String> bodyQuery = {"query": query};

    final url = Uri.https(_baseUrl, "/api/cartera_cxc_cxp");

    final resp = await http.post(url, body: bodyQuery, headers: {
      "auth-token": token,
    });

    if (isCXPX) {
      final getCartera = SaldoCarteraCxpc.fromJson(resp.body);
      onDisplayCarteraCXPX = getCartera.results.content;
      notifyListeners();
    }
    if (!isCXPX) {
      final getCartera = SaldoCartera.fromJson(resp.body);
      onDisplayCartera = getCartera.results.content;
      notifyListeners();
    }
  }

  getDetail_CxPC(String query, String page, String size, String token) async {
    final Map<String, String> queryParams = {"page": page, "size": size};

    final Map<String, String> bodyQuery = {"query": query};

    final url = Uri.https(_baseUrl, "/api/detail_cartera", queryParams);

    final resp = await http.post(url, body: bodyQuery, headers: {
      "auth-token": token,
    });

    final getDetailCxpcResponse = GetDetailCxpcResponse.fromJson(resp.body);
    totalData = getDetailCxpcResponse.results.totalData;
    totalPages = getDetailCxpcResponse.results.totalPages;
    onDisplayDetailsCartera = getDetailCxpcResponse.results.content;
    notifyListeners();
  }
}
