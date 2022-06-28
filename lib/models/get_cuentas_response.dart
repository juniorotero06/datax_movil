import 'dart:convert';

class GetCuentasResponse {
  GetCuentasResponse({
    required this.cuentasxCobrar,
    required this.cuentasxPagar,
  });

  CuentasxCobrar cuentasxCobrar;
  CuentasxPagar cuentasxPagar;

  factory GetCuentasResponse.fromJson(String str) =>
      GetCuentasResponse.fromMap(json.decode(str));

  factory GetCuentasResponse.fromMap(Map<String, dynamic> json) =>
      GetCuentasResponse(
        cuentasxCobrar: CuentasxCobrar.fromMap(json["cuentasxCobrar"]),
        cuentasxPagar: CuentasxPagar.fromMap(json["cuentasxPagar"]),
      );
}

class CuentasxCobrar {
  CuentasxCobrar({
    required this.cxc,
    required this.clase,
  });

  List<Cuentas> cxc;
  String clase;

  factory CuentasxCobrar.fromJson(String str) =>
      CuentasxCobrar.fromMap(json.decode(str));

  factory CuentasxCobrar.fromMap(Map<String, dynamic> json) => CuentasxCobrar(
        cxc: List<Cuentas>.from(json["cxc"].map((x) => Cuentas.fromMap(x))),
        clase: json["clase"],
      );
}

class CuentasxPagar {
  CuentasxPagar({
    required this.cxp,
    required this.clase,
  });

  List<Cuentas> cxp;
  String clase;

  factory CuentasxPagar.fromJson(String str) =>
      CuentasxPagar.fromMap(json.decode(str));

  factory CuentasxPagar.fromMap(Map<String, dynamic> json) => CuentasxPagar(
        cxp: List<Cuentas>.from(json["cxp"].map((x) => Cuentas.fromMap(x))),
        clase: json["clase"],
      );
}

class Cuentas {
  Cuentas({
    required this.cuenta,
    required this.cuentaNom,
  });

  String cuenta;
  String cuentaNom;

  factory Cuentas.fromJson(String str) => Cuentas.fromMap(json.decode(str));

  factory Cuentas.fromMap(Map<String, dynamic> json) => Cuentas(
        cuenta: json["cuenta"],
        cuentaNom: json["cuenta_nom"],
      );
}
