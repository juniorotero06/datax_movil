import 'dart:convert';

class GetFiltersResponse {
  GetFiltersResponse({
    required this.results,
  });

  PaginateWithGrupos results;

  factory GetFiltersResponse.fromJson(String str) =>
      GetFiltersResponse.fromMap(json.decode(str));

  factory GetFiltersResponse.fromMap(Map<String, dynamic> json) =>
      GetFiltersResponse(
        results: PaginateWithGrupos.fromMap(json["results"]),
      );
}

class PaginateWithGrupos {
  PaginateWithGrupos({
    required this.content,
    required this.totalData,
    required this.totalPages,
  });

  List<SaldosWithGrupo> content;
  int totalData;
  int totalPages;

  factory PaginateWithGrupos.fromJson(String str) =>
      PaginateWithGrupos.fromMap(json.decode(str));

  factory PaginateWithGrupos.fromMap(Map<String, dynamic> json) =>
      PaginateWithGrupos(
        content: List<SaldosWithGrupo>.from(
            json["content"].map((x) => SaldosWithGrupo.fromMap(x))),
        totalData: json["totalData"],
        totalPages: json["totalPages"],
      );
}

class SaldosWithGrupo {
  SaldosWithGrupo({
    required this.actualSdo,
    this.desBod,
    this.codSdo,
    this.descrip,
    this.desLinea,
    this.descGru,
  });

  String? desBod;
  String? codSdo;
  String? descrip;
  dynamic actualSdo;
  String? desLinea;
  String? descGru;

  factory SaldosWithGrupo.fromJson(String str) =>
      SaldosWithGrupo.fromMap(json.decode(str));

  factory SaldosWithGrupo.fromMap(Map<String, dynamic> json) => SaldosWithGrupo(
        desBod: json["des_bod"],
        codSdo: json["cod_sdo"],
        descrip: json["descrip"],
        actualSdo: json["actual_sdo"],
        desLinea: json["des_linea"],
        descGru: json["desc_gru"],
      );
}
