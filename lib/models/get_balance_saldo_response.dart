import 'dart:convert';

import 'models.dart';

class GetBalanceSaldoResponse {
  GetBalanceSaldoResponse({
    required this.results,
  });

  SaldosPaginate results;

  factory GetBalanceSaldoResponse.fromJson(String str) =>
      GetBalanceSaldoResponse.fromMap(json.decode(str));

  factory GetBalanceSaldoResponse.fromMap(Map<String, dynamic> json) =>
      GetBalanceSaldoResponse(
        results: SaldosPaginate.fromMap(json["results"]),
      );
}
