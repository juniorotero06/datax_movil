import 'dart:convert';

import 'models.dart';

class GetBalanceLineaResponse {
  GetBalanceLineaResponse({
    required this.results,
  });

  SaldosPaginate results;

  factory GetBalanceLineaResponse.fromJson(String str) =>
      GetBalanceLineaResponse.fromMap(json.decode(str));

  factory GetBalanceLineaResponse.fromMap(Map<String, dynamic> json) =>
      GetBalanceLineaResponse(
        results: SaldosPaginate.fromMap(json["results"]),
      );
}
