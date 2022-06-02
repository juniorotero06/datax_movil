import 'package:datax_movil/models/models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BalanceServices extends ChangeNotifier {
  final String _baseUrl = "10.0.3.2:3001";
  List<Saldos> onDisplaySaldos = [];
  List<SaldosWithGrupo> onDisplaySaldosWithGrupo = [];
  List<Cartera> onDisplayCartera = [];
  List<CarteraCXPC> onDisplayCarteraCXPX = [];
  int totalData = 0, totalPages = 0;

  BalanceServices() {
    getBodega;
    getCodSaldo;
    getLinea;
    getProducto;
    getSaldo;
    getSaldosByFilters;
    getCartera;
  }

  getBodega(String bodega, String page, String size, String token) async {
    final Map<String, String> queryParams = {"page": page, "size": size};

    final Map<String, dynamic> bodyInfo = {"bodega": bodega};

    //final url = Uri.http(_baseUrl, "/api/balance_bodega?page=$page&size=$size");
    final url = Uri.http(_baseUrl, "/api/balance_bodega", queryParams);

    final resp = await http.post(url, body: bodyInfo, headers: {
      "auth-token": token,
    });

    final getBalanceBodegaResponse =
        GetBalanceBodegaResponse.fromJson(resp.body);

    totalData = getBalanceBodegaResponse.results.totalData;
    totalPages = getBalanceBodegaResponse.results.totalPages;
    onDisplaySaldos = getBalanceBodegaResponse.results.content;
    notifyListeners();
  }

  getCodSaldo(String codSaldo, String page, String size, String token) async {
    final Map<String, String> queryParams = {"page": page, "size": size};

    final Map<String, String> bodyInfo = {"codSaldo": codSaldo};

    final url = Uri.http(_baseUrl, "/api/balance_codsaldo", queryParams);

    final resp = await http.post(url, body: bodyInfo, headers: {
      "auth-token": token,
    });

    final getBalanceCodSaldoResponse =
        GetBalanceCodSaldoResponse.fromJson(resp.body);

    totalData = getBalanceCodSaldoResponse.results.totalData;
    totalPages = getBalanceCodSaldoResponse.results.totalPages;
    onDisplaySaldos = getBalanceCodSaldoResponse.results.content;
    notifyListeners();
  }

  getLinea(String linea, String page, String size, String token) async {
    final Map<String, String> queryParams = {"page": page, "size": size};

    final Map<String, String> bodyInfo = {"linea": linea};

    final url = Uri.http(_baseUrl, "/api/balance_linea", queryParams);

    final resp = await http.post(url, body: bodyInfo, headers: {
      "auth-token": token,
    });

    final getBalanceLineaResponse = GetBalanceLineaResponse.fromJson(resp.body);

    totalData = getBalanceLineaResponse.results.totalData;
    totalPages = getBalanceLineaResponse.results.totalPages;
    onDisplaySaldos = getBalanceLineaResponse.results.content;
    notifyListeners();
  }

  getProducto(String producto, String page, String size, String token) async {
    final Map<String, String> queryParams = {"page": page, "size": size};

    final Map<String, String> bodyInfo = {"nomProducto": producto};

    final url = Uri.http(_baseUrl, "/api/balance_producto", queryParams);

    final resp = await http.post(url, body: bodyInfo, headers: {
      "auth-token": token,
    });

    final getBalanceProductoResponse =
        GetBalanceProductoResponse.fromJson(resp.body);

    totalData = getBalanceProductoResponse.results.totalData;
    totalPages = getBalanceProductoResponse.results.totalPages;
    onDisplaySaldos = getBalanceProductoResponse.results.content;
    notifyListeners();
  }

  getSaldo(String operador, String page, String size, String token) async {
    final Map<String, String> queryParams = {"page": page, "size": size};

    final Map<String, String> bodyInfo = {"operator": operador};

    final url = Uri.http(_baseUrl, "/api/balance_saldo", queryParams);

    final resp = await http.post(url, body: bodyInfo, headers: {
      "auth-token": token,
    });

    final getBalanceSaldoResponse = GetBalanceSaldoResponse.fromJson(resp.body);

    totalData = getBalanceSaldoResponse.results.totalData;
    totalPages = getBalanceSaldoResponse.results.totalPages;
    onDisplaySaldos = getBalanceSaldoResponse.results.content;
    notifyListeners();
  }

  getSaldosByFilters(
      String query, String page, String size, String token) async {
    final Map<String, String> queryParams = {"page": page, "size": size};

    final Map<String, String> bodyQuery = {"query": query};

    final url = Uri.http(_baseUrl, "/api/balance_filters", queryParams);

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

    final url = Uri.http(_baseUrl, "/api/cartera_cxc_cxp");

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
}
