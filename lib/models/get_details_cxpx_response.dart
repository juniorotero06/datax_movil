import 'dart:convert';

class GetDetailCxpcResponse {
  GetDetailCxpcResponse({
    required this.results,
  });

  ResultsDetailsCartera results;

  factory GetDetailCxpcResponse.fromJson(String str) =>
      GetDetailCxpcResponse.fromMap(json.decode(str));

  factory GetDetailCxpcResponse.fromMap(Map<String, dynamic> json) =>
      GetDetailCxpcResponse(
        results: ResultsDetailsCartera.fromMap(json["results"]),
      );
}

class ResultsDetailsCartera {
  ResultsDetailsCartera({
    required this.content,
    required this.totalData,
    required this.totalPages,
  });

  List<DetailsCartera> content;
  int totalData;
  int totalPages;

  factory ResultsDetailsCartera.fromJson(String str) =>
      ResultsDetailsCartera.fromMap(json.decode(str));

  factory ResultsDetailsCartera.fromMap(Map<String, dynamic> json) =>
      ResultsDetailsCartera(
        content: List<DetailsCartera>.from(
            json["content"].map((x) => DetailsCartera.fromMap(x))),
        totalData: json["totalData"],
        totalPages: json["totalPages"],
      );
}

class DetailsCartera {
  DetailsCartera({
    this.tercero,
    this.terceroNom,
    this.dcmnto,
    this.saldo,
    this.vence,
    this.diasVence,
  });

  String? tercero;
  String? terceroNom;
  String? dcmnto;
  double? saldo;
  DateTime? vence;
  int? diasVence;

  factory DetailsCartera.fromJson(String str) =>
      DetailsCartera.fromMap(json.decode(str));

  factory DetailsCartera.fromMap(Map<String, dynamic> json) => DetailsCartera(
        tercero: json["tercero"],
        terceroNom: json["tercero_nom"],
        dcmnto: json["dcmnto"],
        saldo: json["saldo"].toDouble(),
        vence: DateTime.parse(json["vence"]),
        diasVence: json["DIAS_VENCE"],
      );
}
