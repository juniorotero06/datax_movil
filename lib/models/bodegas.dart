import 'dart:convert';

class Bodegas {
  Bodegas({
    required this.codBod,
    required this.desBod,
  });

  String codBod;
  String desBod;

  factory Bodegas.fromJson(String str) => Bodegas.fromMap(json.decode(str));

  factory Bodegas.fromMap(Map<String, dynamic> json) => Bodegas(
        codBod: json["cod_bod"],
        desBod: json["des_bod"],
      );
}
