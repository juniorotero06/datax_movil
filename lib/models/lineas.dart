import 'dart:convert';

class Lineas {
  Lineas({
    required this.codLinea,
    required this.desLinea,
  });

  String codLinea;
  String desLinea;

  factory Lineas.fromJson(String str) => Lineas.fromMap(json.decode(str));

  factory Lineas.fromMap(Map<String, dynamic> json) => Lineas(
        codLinea: json["cod_linea"],
        desLinea: json["des_linea"],
      );
}
