import 'dart:convert';

import 'models.dart';

class GetBalanceCodSaldoResponse {
  GetBalanceCodSaldoResponse({
    required this.results,
  });

  SaldosPaginate results;

  factory GetBalanceCodSaldoResponse.fromJson(String str) =>
      GetBalanceCodSaldoResponse.fromMap(json.decode(str));

  factory GetBalanceCodSaldoResponse.fromMap(Map<String, dynamic> json) =>
      GetBalanceCodSaldoResponse(
        results: SaldosPaginate.fromMap(json["results"]),
      );
}
