import 'dart:convert';

import 'models.dart';

class GetBalanceProductoResponse {
  GetBalanceProductoResponse({
    required this.results,
  });

  SaldosPaginate results;

  factory GetBalanceProductoResponse.fromJson(String str) =>
      GetBalanceProductoResponse.fromMap(json.decode(str));

  factory GetBalanceProductoResponse.fromMap(Map<String, dynamic> json) =>
      GetBalanceProductoResponse(
        results: SaldosPaginate.fromMap(json["results"]),
      );
}
