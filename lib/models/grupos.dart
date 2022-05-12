import 'dart:convert';

class Grupos {
  Grupos({
    required this.tipoGru,
    required this.descGru,
    this.codigoGru,
  });

  String tipoGru;
  String? codigoGru;
  String descGru;

  factory Grupos.fromJson(String str) => Grupos.fromMap(json.decode(str));

  factory Grupos.fromMap(Map<String, dynamic> json) => Grupos(
        tipoGru: json["tipo_gru"],
        codigoGru: json["codigo_gru"],
        descGru: json["desc_gru"],
      );
}
