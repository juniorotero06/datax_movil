import 'dart:convert';

class SaldoCartera {
  SaldoCartera({
    required this.results,
  });

  Results results;

  factory SaldoCartera.fromJson(String str) =>
      SaldoCartera.fromMap(json.decode(str));

  factory SaldoCartera.fromMap(Map<String, dynamic> json) => SaldoCartera(
        results: Results.fromMap(json["results"]),
      );
}

class Results {
  Results({
    required this.content,
  });

  List<Cartera> content;

  factory Results.fromJson(String str) => Results.fromMap(json.decode(str));

  factory Results.fromMap(Map<String, dynamic> json) => Results(
        content:
            List<Cartera>.from(json["content"].map((x) => Cartera.fromMap(x))),
      );
}

class Cartera {
  Cartera({
    this.tipo,
    this.documentos,
    this.vrSaldo,
  });

  String? tipo;
  int? documentos;
  double? vrSaldo;

  factory Cartera.fromJson(String str) => Cartera.fromMap(json.decode(str));

  factory Cartera.fromMap(Map<String, dynamic> json) => Cartera(
        tipo: json["TIPO"],
        documentos: json["Documentos"],
        vrSaldo: json["vr_saldo"].toDouble(),
      );
}
