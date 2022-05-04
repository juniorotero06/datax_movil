import 'dart:convert';

class Saldos {
  Saldos({
    required this.desBod,
    required this.codSdo,
    required this.descrip,
    required this.actualSdo,
    required this.desLinea,
  });

  String desBod;
  String codSdo;
  String descrip;
  int actualSdo;
  String desLinea;

  factory Saldos.fromJson(String str) => Saldos.fromMap(json.decode(str));

  factory Saldos.fromMap(Map<String, dynamic> json) => Saldos(
        desBod: json["des_bod"],
        codSdo: json["cod_sdo"],
        descrip: json["descrip"],
        actualSdo: json["actual_sdo"],
        desLinea: json["des_linea"],
      );
}
