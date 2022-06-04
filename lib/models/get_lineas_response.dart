import 'dart:convert';

import 'models.dart';

class GetLineasResponse {
  GetLineasResponse({
    required this.results,
  });

  List<Lineas> results;

  factory GetLineasResponse.fromJson(String str) =>
      GetLineasResponse.fromMap(json.decode(str));

  factory GetLineasResponse.fromMap(Map<String, dynamic> json) =>
      GetLineasResponse(
        results:
            List<Lineas>.from(json["results"].map((x) => Lineas.fromMap(x))),
      );
}
