import 'dart:convert';

class SaldoCarteraCxpc {
  SaldoCarteraCxpc({
    required this.results,
  });

  ResultsCXPC results;

  factory SaldoCarteraCxpc.fromJson(String str) =>
      SaldoCarteraCxpc.fromMap(json.decode(str));

  factory SaldoCarteraCxpc.fromMap(Map<String, dynamic> json) =>
      SaldoCarteraCxpc(
        results: ResultsCXPC.fromMap(json["results"]),
      );
}

class ResultsCXPC {
  ResultsCXPC({
    required this.content,
  });

  List<CarteraCXPC> content;

  factory ResultsCXPC.fromJson(String str) =>
      ResultsCXPC.fromMap(json.decode(str));

  factory ResultsCXPC.fromMap(Map<String, dynamic> json) => ResultsCXPC(
        content: List<CarteraCXPC>.from(
            json["content"].map((x) => CarteraCXPC.fromMap(x))),
      );
}

class CarteraCXPC {
  CarteraCXPC({
    this.clase,
    this.tipo,
    this.documentos,
    this.vrSaldo,
  });

  String? clase;
  String? tipo;
  int? documentos;
  dynamic vrSaldo;

  factory CarteraCXPC.fromJson(String str) =>
      CarteraCXPC.fromMap(json.decode(str));

  factory CarteraCXPC.fromMap(Map<String, dynamic> json) => CarteraCXPC(
        clase: json["CLASE"],
        tipo: json["TIPO"],
        documentos: json["Documentos"],
        vrSaldo: json["vr_saldo"],
      );
}
