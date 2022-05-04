import 'dart:convert';

import 'models.dart';

class GetBalanceBodegaResponse {
  GetBalanceBodegaResponse({
    required this.results,
  });

  SaldosPaginate results;

  factory GetBalanceBodegaResponse.fromJson(String str) =>
      GetBalanceBodegaResponse.fromMap(json.decode(str));

  factory GetBalanceBodegaResponse.fromMap(Map<String, dynamic> json) =>
      GetBalanceBodegaResponse(
        results: SaldosPaginate.fromMap(json["results"]),
      );
}
