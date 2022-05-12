import 'dart:convert';

import 'models.dart';

class GetBodegasResponse {
  GetBodegasResponse({
    required this.results,
  });

  List<Bodegas> results;

  factory GetBodegasResponse.fromJson(String str) =>
      GetBodegasResponse.fromMap(json.decode(str));

  factory GetBodegasResponse.fromMap(Map<String, dynamic> json) =>
      GetBodegasResponse(
        results:
            List<Bodegas>.from(json["results"].map((x) => Bodegas.fromMap(x))),
      );
}
