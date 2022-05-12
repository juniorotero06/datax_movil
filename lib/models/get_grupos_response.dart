import 'dart:convert';

import 'models.dart';

class GetGruposResponse {
  GetGruposResponse({
    required this.results,
  });

  List<Grupos> results;

  factory GetGruposResponse.fromJson(String str) =>
      GetGruposResponse.fromMap(json.decode(str));

  factory GetGruposResponse.fromMap(Map<String, dynamic> json) =>
      GetGruposResponse(
        results:
            List<Grupos>.from(json["results"].map((x) => Grupos.fromMap(x))),
      );
}
