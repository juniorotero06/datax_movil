import 'dart:convert';

import 'models.dart';

class SaldosPaginate {
  SaldosPaginate({
    required this.content,
    required this.totalData,
    required this.totalPages,
  });

  List<Saldos> content;
  int totalData;
  int totalPages;

  factory SaldosPaginate.fromJson(String str) =>
      SaldosPaginate.fromMap(json.decode(str));

  factory SaldosPaginate.fromMap(Map<String, dynamic> json) => SaldosPaginate(
        content:
            List<Saldos>.from(json["content"].map((x) => Saldos.fromMap(x))),
        totalData: json["totalData"],
        totalPages: json["totalPages"],
      );
}
