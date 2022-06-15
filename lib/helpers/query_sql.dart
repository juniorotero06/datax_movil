String querySQL(String codProducto, String producto, String bodega,
    String linea, String grupo, String saldos, int page, int size) {
  var desGrupo;
  var desLinea;
  // String query =
  //     "SELECT a.des_bod, b.cod_sdo, c.descrip, b.actual_sdo, d.des_linea, e.desc_gru FROM insaldo as b JOIN inbodega as a JOIN initem as c on c.cod_item = b.cod_sdo JOIN inlinea as d on c.itm_linea = d.cod_linea JOIN ingrupo as e WHERE";

  String query =
      "SELECT a.des_bod, b.cod_sdo, c.descrip, b.actual_sdo, d.des_linea, e.desc_gru FROM insaldo as b LEFT JOIN inbodega as a ON a.cod_bod = b.bod_sdo LEFT JOIN initem as c ON c.cod_item = b.cod_sdo LEFT JOIN inlinea as d ON d.cod_linea = c.itm_linea LEFT JOIN ingrupo as e ON concat(e.tipo_gru, e.codigo_gru) = c.grupo WHERE ";

  if (codProducto != "") {
    query = "$query b.cod_sdo LIKE '%$codProducto%'";
  }

  if (producto != "") {
    if (codProducto != "") {
      query = "$query AND";
    }
    query = "$query c.descrip LIKE '%$producto%'";
  }

  if (bodega != "") {
    if (codProducto != "" || producto != "") {
      query = "$query AND";
    }
    query = "$query a.des_bod LIKE '%$bodega%'";
  }

  if (linea != "") {
    if (codProducto != "" || producto != "" || bodega != "") {
      query = "$query AND";
    }
    desLinea = linea.split("||");
    query = "$query d.des_linea LIKE '%${desLinea[1]}%'";
  }

  if (grupo != "") {
    if (codProducto != "" || producto != "" || bodega != "" || linea != "") {
      query = "$query AND";
    }
    desGrupo = grupo.split("||");
    query = "$query e.desc_gru LIKE '%${desGrupo[1]}%'";
  }

  if (saldos == "Saldos Positivos") {
    if (codProducto != "" ||
        producto != "" ||
        bodega != "" ||
        linea != "" ||
        grupo != "") {
      query = "$query AND";
    }
    query = "$query b.actual_sdo > 0";
  }

  if (saldos == "Saldos Iguales a 0") {
    if (codProducto != "" ||
        producto != "" ||
        bodega != "" ||
        linea != "" ||
        grupo != "") {
      query = "$query AND";
    }
    query = "$query b.actual_sdo = 0";
  }

  if (saldos == "Saldos Negativos") {
    if (codProducto != "" ||
        producto != "" ||
        bodega != "" ||
        linea != "" ||
        grupo != "") {
      query = "$query AND";
    }
    query = "$query b.actual_sdo < 0";
  }

  if (codProducto == "" &&
      producto == "" &&
      bodega == "" &&
      linea == "" &&
      grupo == "" &&
      saldos == "") {
    return "SELECT a.des_bod, b.cod_sdo, c.descrip, b.actual_sdo, d.des_linea, e.desc_gru FROM insaldo as b JOIN inbodega as a JOIN initem as c on c.cod_item = b.cod_sdo JOIN inlinea as d on c.itm_linea = d.cod_linea JOIN ingrupo as e ORDER BY b.cod_sdo ASC LIMIT $size OFFSET ${page * size}";
  }

  return "$query ORDER BY b.cod_sdo ASC LIMIT $size OFFSET ${page * size}";
}

//?Resumen Cuentas por pagar y cuentas por cobrar
String queryCXX_CXP(bool checkCXC, bool checkCXP, bool isCXPC, String cuenta,
    String codTercero, String nomTercero) {
  List<String> desCuenta = cuenta.split("||");
  //? CXC ///////////////////////////////////////////////////////////
  if (checkCXC && !checkCXP && !isCXPC) {
    if (cuenta != "" && codTercero == "" && nomTercero == "") {
      return "SELECT 'CORRIENTE' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo  FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)<=0 AND cuenta_nom LIKE '%${desCuenta[1]}%' UNION SELECT '1 A 30' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)>0 AND DATEDIFF(NOW(),vence)<=30 AND cuenta_nom LIKE '%${desCuenta[1]}%' UNION SELECT '31 A 60' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)>30 AND DATEDIFF(NOW(),vence)<=60 AND cuenta_nom LIKE '%${desCuenta[1]}%' UNION SELECT '61 A 90' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)>60 AND DATEDIFF(NOW(),vence)<=90 AND cuenta_nom LIKE '%${desCuenta[1]}%' UNION SELECT '91 A 120' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)>90 AND DATEDIFF(NOW(),vence)<=120 AND cuenta_nom LIKE '%${desCuenta[1]}%' UNION SELECT 'MAYOR 120' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)>120 AND cuenta_nom LIKE '%${desCuenta[1]}%'";
    }
    if (codTercero != "") {
      if (cuenta != "") {
        return "SELECT 'CORRIENTE' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo  FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)<=0 AND cuenta LIKE '%${desCuenta[0]}%' AND tercero LIKE '%$codTercero%' UNION SELECT '1 A 30' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)>0 AND DATEDIFF(NOW(),vence)<=30 AND cuenta LIKE '%${desCuenta[0]}%' AND tercero LIKE '%$codTercero%' UNION SELECT '31 A 60' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)>30 AND DATEDIFF(NOW(),vence)<=60 AND cuenta LIKE '%${desCuenta[0]}%' AND tercero LIKE '%$codTercero%' UNION SELECT '61 A 90' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)>60 AND DATEDIFF(NOW(),vence)<=90 AND cuenta LIKE '%${desCuenta[0]}%' AND tercero LIKE '%$codTercero%' UNION SELECT '91 A 120' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)>90 AND DATEDIFF(NOW(),vence)<=120 AND cuenta LIKE '%${desCuenta[0]}%' AND tercero LIKE '%$codTercero%' UNION SELECT 'MAYOR 120' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)>120 AND cuenta LIKE '%${desCuenta[0]}%' AND tercero LIKE '%$codTercero%'";
      }
      return "SELECT 'CORRIENTE' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo  FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)<=0 AND tercero LIKE '%$codTercero%' UNION SELECT '1 A 30' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)>0 AND DATEDIFF(NOW(),vence)<=30 AND tercero LIKE '%$codTercero%' UNION SELECT '31 A 60' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)>30 AND DATEDIFF(NOW(),vence)<=60 AND tercero LIKE '%$codTercero%' UNION SELECT '61 A 90' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)>60 AND DATEDIFF(NOW(),vence)<=90 AND tercero LIKE '%$codTercero%' UNION SELECT '91 A 120' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)>90 AND DATEDIFF(NOW(),vence)<=120 AND tercero LIKE '%$codTercero%' UNION SELECT 'MAYOR 120' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)>120 AND tercero LIKE '%$codTercero%'";
    }
    if (nomTercero != "") {
      if (cuenta != "" && codTercero == "") {
        return "SELECT 'CORRIENTE' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo  FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)<=0 AND cuenta LIKE '%${desCuenta[0]}%' AND tercero_nom LIKE '%$nomTercero%' UNION SELECT '1 A 30' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)>0 AND DATEDIFF(NOW(),vence)<=30 AND cuenta LIKE '%${desCuenta[0]}%' AND tercero_nom LIKE '%$nomTercero%' UNION SELECT '31 A 60' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)>30 AND DATEDIFF(NOW(),vence)<=60 AND cuenta LIKE '%${desCuenta[0]}%' AND tercero_nom LIKE '%$nomTercero%' UNION SELECT '61 A 90' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)>60 AND DATEDIFF(NOW(),vence)<=90 AND cuenta LIKE '%${desCuenta[0]}%' AND tercero_nom LIKE '%$nomTercero%' UNION SELECT '91 A 120' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)>90 AND DATEDIFF(NOW(),vence)<=120 AND cuenta LIKE '%${desCuenta[0]}%' AND tercero_nom LIKE '%$nomTercero%' UNION SELECT 'MAYOR 120' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)>120 AND cuenta LIKE '%${desCuenta[0]}%' AND tercero_nom LIKE '%$nomTercero%'";
      }
      if (codTercero != "" && cuenta == "") {
        return "SELECT 'CORRIENTE' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo  FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)<=0 AND tercero LIKE '%$codTercero%' AND tercero_nom LIKE '%$nomTercero%' UNION SELECT '1 A 30' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)>0 AND DATEDIFF(NOW(),vence)<=30 AND tercero LIKE '%$codTercero%' AND tercero_nom LIKE '%$nomTercero%' UNION SELECT '31 A 60' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)>30 AND DATEDIFF(NOW(),vence)<=60 AND tercero LIKE '%$codTercero%' AND tercero_nom LIKE '%$nomTercero%' UNION SELECT '61 A 90' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)>60 AND DATEDIFF(NOW(),vence)<=90 AND tercero LIKE '%$codTercero%' AND tercero_nom LIKE '%$nomTercero%' UNION SELECT '91 A 120' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)>90 AND DATEDIFF(NOW(),vence)<=120 AND tercero LIKE '%$codTercero%' AND tercero_nom LIKE '%$nomTercero%' UNION SELECT 'MAYOR 120' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)>120 AND tercero LIKE '%$codTercero%' AND tercero_nom LIKE '%$nomTercero%'";
      }
      if (codTercero != "" && cuenta != "") {
        return "SELECT 'CORRIENTE' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo  FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)<=0 AND cuenta LIKE '%${desCuenta[0]}%' AND tercero LIKE '%$codTercero%' AND tercero_nom LIKE '%$nomTercero%' UNION SELECT '1 A 30' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)>0 AND DATEDIFF(NOW(),vence)<=30 AND cuenta LIKE '%${desCuenta[0]}%' AND tercero LIKE '%$codTercero%' AND tercero_nom LIKE '%$nomTercero%' UNION SELECT '31 A 60' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)>30 AND DATEDIFF(NOW(),vence)<=60 AND cuenta LIKE '%${desCuenta[0]}%' AND tercero LIKE '%$codTercero%' AND tercero_nom LIKE '%$nomTercero%' UNION SELECT '61 A 90' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)>60 AND DATEDIFF(NOW(),vence)<=90 AND cuenta LIKE '%${desCuenta[0]}%' AND tercero LIKE '%$codTercero%' AND tercero_nom LIKE '%$nomTercero%' UNION SELECT '91 A 120' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)>90 AND DATEDIFF(NOW(),vence)<=120 AND cuenta LIKE '%${desCuenta[0]}%' AND tercero LIKE '%$codTercero%' AND tercero_nom LIKE '%$nomTercero%' UNION SELECT 'MAYOR 120' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)>120 AND cuenta LIKE '%${desCuenta[0]}%' AND tercero LIKE '%$codTercero%' AND tercero_nom LIKE '%$nomTercero%'";
      }
      return "SELECT 'CORRIENTE' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo  FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)<=0 AND tercero_nom LIKE '%$nomTercero%' UNION SELECT '1 A 30' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)>0 AND DATEDIFF(NOW(),vence)<=30 AND tercero_nom LIKE '%$nomTercero%' UNION SELECT '31 A 60' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)>30 AND DATEDIFF(NOW(),vence)<=60 AND tercero_nom LIKE '%$nomTercero%' UNION SELECT '61 A 90' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)>60 AND DATEDIFF(NOW(),vence)<=90 AND tercero_nom LIKE '%$nomTercero%' UNION SELECT '91 A 120' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)>90 AND DATEDIFF(NOW(),vence)<=120 AND tercero_nom LIKE '%$nomTercero%' UNION SELECT 'MAYOR 120' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)>120 AND tercero_nom LIKE '%$nomTercero%'";
    }
    return "SELECT 'CORRIENTE' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo  FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)<=0 UNION SELECT '1 A 30' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)>0 AND DATEDIFF(NOW(),vence)<=30 UNION SELECT '31 A 60' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)>30 AND DATEDIFF(NOW(),vence)<=60 UNION SELECT '61 A 90' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)>60 AND DATEDIFF(NOW(),vence)<=90 UNION SELECT '91 A 120' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)>90 AND DATEDIFF(NOW(),vence)<=120 UNION SELECT 'MAYOR 120' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)>120";
  }
  //? CXP ///////////////////////////////////////////////////////////
  if (checkCXP && !checkCXC && !isCXPC) {
    if (cuenta != "" && codTercero == "" && nomTercero == "") {
      return "SELECT 'CORRIENTE' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo  FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)<=0 AND cuenta LIKE '%${desCuenta[0]}%' UNION SELECT '1 A 30' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)>0 AND DATEDIFF(NOW(),vence)<=30 AND cuenta LIKE '%${desCuenta[0]}%' UNION SELECT '31 A 60' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)>30 AND DATEDIFF(NOW(),vence)<=60 AND cuenta LIKE '%${desCuenta[0]}%' UNION SELECT '61 A 90' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)>60 AND DATEDIFF(NOW(),vence)<=90 AND cuenta LIKE '%${desCuenta[0]}%' UNION SELECT '91 A 120' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)>90 AND DATEDIFF(NOW(),vence)<=120 AND cuenta LIKE '%${desCuenta[0]}%' UNION SELECT 'MAYOR 120' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)>120 AND cuenta LIKE '%${desCuenta[0]}%'";
    }
    if (codTercero != "") {
      if (cuenta != "") {
        return "SELECT 'CORRIENTE' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo  FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)<=0 AND cuenta LIKE '%${desCuenta[0]}%' AND tercero LIKE '%$codTercero%' UNION SELECT '1 A 30' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)>0 AND DATEDIFF(NOW(),vence)<=30 AND cuenta LIKE '%${desCuenta[0]}%' AND tercero LIKE '%$codTercero%' UNION SELECT '31 A 60' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)>30 AND DATEDIFF(NOW(),vence)<=60 AND cuenta LIKE '%${desCuenta[0]}%' AND tercero LIKE '%$codTercero%' UNION SELECT '61 A 90' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)>60 AND DATEDIFF(NOW(),vence)<=90 AND cuenta LIKE '%${desCuenta[0]}%' AND tercero LIKE' %$codTercero%' UNION SELECT '91 A 120' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)>90 AND DATEDIFF(NOW(),vence)<=120 AND cuenta LIKE '%${desCuenta[0]}%' AND tercero LIKE '%$codTercero%' UNION SELECT 'MAYOR 120' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)>120 AND cuenta LIKE '%${desCuenta[0]}%' AND tercero LIKE '%$codTercero%'";
      }
      return "SELECT 'CORRIENTE' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo  FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)<=0 AND tercero LIKE '%$codTercero%' UNION SELECT '1 A 30' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)>0 AND DATEDIFF(NOW(),vence)<=30 AND tercero LIKE '%$codTercero%' UNION SELECT '31 A 60' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)>30 AND DATEDIFF(NOW(),vence)<=60 AND tercero LIKE '%$codTercero%' UNION SELECT '61 A 90' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)>60 AND DATEDIFF(NOW(),vence)<=90 AND tercero LIKE '%$codTercero%' UNION SELECT '91 A 120' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)>90 AND DATEDIFF(NOW(),vence)<=120 AND tercero LIKE '%$codTercero%' UNION SELECT 'MAYOR 120' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)>120 AND tercero LIKE '%$codTercero%'";
    }
    if (nomTercero != "") {
      if (cuenta != "" && codTercero == "") {
        return "SELECT 'CORRIENTE' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo  FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)<=0 AND cuenta LIKE '%${desCuenta[0]}%' AND tercero_nom LIKE '%$nomTercero%' UNION SELECT '1 A 30' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)>0 AND DATEDIFF(NOW(),vence)<=30 AND cuenta LIKE '%${desCuenta[0]}%' AND tercero_nom LIKE '%$nomTercero%' UNION SELECT '31 A 60' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)>30 AND DATEDIFF(NOW(),vence)<=60 AND cuenta LIKE '%${desCuenta[0]}%' AND tercero_nom LIKE '%$nomTercero%' UNION SELECT '61 A 90' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)>60 AND DATEDIFF(NOW(),vence)<=90 AND cuenta LIKE '%${desCuenta[0]}%' AND tercero_nom LIKE '%$nomTercero%' UNION SELECT '91 A 120' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)>90 AND DATEDIFF(NOW(),vence)<=120 AND cuenta LIKE '%${desCuenta[0]}%' AND tercero_nom LIKE '%$nomTercero%' UNION SELECT 'MAYOR 120' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)>120 AND cuenta LIKE '%${desCuenta[0]}%' AND tercero_nom LIKE '%$nomTercero%'";
      }
      if (codTercero != "" && cuenta == "") {
        return "SELECT 'CORRIENTE' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo  FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)<=0 AND tercero LIKE '%$codTercero%' AND tercero_nom LIKE '%$nomTercero%' UNION SELECT '1 A 30' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)>0 AND DATEDIFF(NOW(),vence)<=30 AND tercero LIKE '%$codTercero%' AND tercero_nom LIKE '%$nomTercero%' UNION SELECT '31 A 60' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)>30 AND DATEDIFF(NOW(),vence)<=60 AND tercero LIKE '%$codTercero%' AND tercero_nom LIKE '%$nomTercero%' UNION SELECT '61 A 90' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)>60 AND DATEDIFF(NOW(),vence)<=90 AND tercero LIKE '%$codTercero%' AND tercero_nom LIKE '%$nomTercero%' UNION SELECT '91 A 120' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)>90 AND DATEDIFF(NOW(),vence)<=120 AND tercero LIKE '%$codTercero%' AND tercero_nom LIKE '%$nomTercero%' UNION SELECT 'MAYOR 120' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)>120 AND tercero LIKE '%$codTercero%' AND tercero_nom LIKE '%$nomTercero%'";
      }
      if (codTercero != "" && cuenta != "") {
        return "SELECT 'CORRIENTE' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo  FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)<=0 AND cuenta LIKE '%${desCuenta[0]}%' AND tercero LIKE '%$codTercero%' AND tercero_nom LIKE '%$nomTercero%' UNION SELECT '1 A 30' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)>0 AND DATEDIFF(NOW(),vence)<=30 AND cuenta LIKE '%${desCuenta[0]}%' AND tercero LIKE '%$codTercero%' AND tercero_nom LIKE '%$nomTercero%' UNION SELECT '31 A 60' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)>30 AND DATEDIFF(NOW(),vence)<=60 AND cuenta LIKE '%${desCuenta[0]}%' AND tercero LIKE '%$codTercero%' AND tercero_nom LIKE '%$nomTercero%' UNION SELECT '61 A 90' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)>60 AND DATEDIFF(NOW(),vence)<=90 AND cuenta LIKE '%${desCuenta[0]}%' AND tercero LIKE '%$codTercero%' AND tercero_nom LIKE '%$nomTercero%' UNION SELECT '91 A 120' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)>90 AND DATEDIFF(NOW(),vence)<=120 AND cuenta LIKE '%${desCuenta[0]}%' AND tercero LIKE '%$codTercero%' AND tercero_nom LIKE '%$nomTercero%' UNION SELECT 'MAYOR 120' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)>120 AND cuenta LIKE '%${desCuenta[0]}%' AND tercero LIKE '%$codTercero%' AND tercero_nom LIKE '%$nomTercero%'";
      }
      return "SELECT 'CORRIENTE' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo  FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)<=0 AND tercero_nom LIKE '%$nomTercero%' UNION SELECT '1 A 30' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)>0 AND DATEDIFF(NOW(),vence)<=30 AND tercero_nom LIKE '%$nomTercero%' UNION SELECT '31 A 60' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)>30 AND DATEDIFF(NOW(),vence)<=60 AND tercero_nom LIKE '%$nomTercero%' UNION SELECT '61 A 90' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)>60 AND DATEDIFF(NOW(),vence)<=90 AND tercero_nom LIKE '%$nomTercero%' UNION SELECT '91 A 120' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)>90 AND DATEDIFF(NOW(),vence)<=120 AND tercero_nom LIKE '%$nomTercero%' UNION SELECT 'MAYOR 120' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)>120 AND tercero_nom LIKE '%$nomTercero%'";
    }
    return "SELECT 'CORRIENTE' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo  FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)<=0 UNION SELECT '1 A 30' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)>0 AND DATEDIFF(NOW(),vence)<=30 UNION SELECT '31 A 60' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)>30 AND DATEDIFF(NOW(),vence)<=60 UNION SELECT '61 A 90' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)>60 AND DATEDIFF(NOW(),vence)<=90 UNION SELECT '91 A 120' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)>90 AND DATEDIFF(NOW(),vence)<=120 UNION SELECT 'MAYOR 120' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)>120";
  }

  //? CXP y CXC /////////////////////////////////////////////////////////////////////////
  if (isCXPC) {
    return "SELECT 'CXC' AS CLASE, 'CORRIENTE' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo  FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)<=0 UNION SELECT 'CXP' AS CLASE, 'CORRIENTE' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo  FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)<=0 UNION SELECT 'CXC' AS CLASE, '1 A 30' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)>0 AND DATEDIFF(NOW(),vence)<=30 UNION SELECT 'CXP' AS CLASE, '1 A 30' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)>0 AND DATEDIFF(NOW(),vence)<=30 UNION SELECT 'CXC' AS CLASE, '31 A 60' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)>30 AND DATEDIFF(NOW(),vence)<=60 UNION SELECT 'CXP' AS CLASE, '31 A 60' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)>30 AND DATEDIFF(NOW(),vence)<=60 UNION SELECT 'CXC' AS CLASE, '61 A 90' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)>60 AND DATEDIFF(NOW(),vence)<=90 UNION SELECT 'CXP' AS CLASE, '61 A 90' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)>60 AND DATEDIFF(NOW(),vence)<=90 UNION SELECT 'CXC' AS CLASE, '91 A 120' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)>90 AND DATEDIFF(NOW(),vence)<=120 UNION SELECT 'CXP' AS CLASE, '91 A 120' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)>90 AND DATEDIFF(NOW(),vence)<=120 UNION SELECT 'CXC' AS CLASE, 'MAYOR 120' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxc WHERE DATEDIFF(NOW(),vence)>120 UNION SELECT 'CXP' AS CLASE, 'MAYOR 120' AS TIPO, COUNT(*) AS Documentos, SUM(saldo) AS vr_saldo FROM saldo_cxp WHERE DATEDIFF(NOW(),vence)>120";
  }
  return "";
}

//? Quey Detalles de cartera

String queryDetails_CXPC(String clase, String tipo, int page, int size,
    String cuenta, String codTercero, String nomTercero) {
  List<String> desCuenta = cuenta.split("||");
  if (clase == "CXC") {
    String query =
        "SELECT tercero, tercero_nom, dcmnto, saldo, vence, DATEDIFF(NOW(),vence) AS DIAS_VENCE, cuenta, cuenta_nom FROM saldo_cxc WHERE";

    if (tipo == "CORRIENTE") {
      if (cuenta != "" && codTercero == "" && nomTercero == "") {
        //
      }
      if (codTercero != "") {
        if (cuenta != "") {}
        //
      }
      if (nomTercero != "") {
        if (cuenta != "" && codTercero == "") {
          //
        }
        if (codTercero != "" && cuenta == "") {
          //
        }
        if (codTercero != "" && cuenta != "") {
          //
        }
        //
      }
      query = "$query DATEDIFF(NOW(),vence)<=0";
    }
    if (tipo == "1 A 30") {
      query = "$query DATEDIFF(NOW(),vence)>0 AND DATEDIFF(NOW(),vence)<=30";
    }
    if (tipo == "31 A 60") {
      query = "$query DATEDIFF(NOW(),vence)>30 AND DATEDIFF(NOW(),vence)<=60";
    }
    if (tipo == "61 A 90") {
      query = "$query DATEDIFF(NOW(),vence)>60 AND DATEDIFF(NOW(),vence)<=90";
    }
    if (tipo == "91 A 120") {
      query = "$query DATEDIFF(NOW(),vence)>90 AND DATEDIFF(NOW(),vence)<=120";
    }
    if (tipo == "MAYOR 120") {
      query = "$query DATEDIFF(NOW(),vence)>120";
    }
    return "$query ORDER BY DIAS_VENCE DESC LIMIT $size OFFSET ${page * size}";
  }
  if (clase == "CXP") {
    String query =
        "SELECT tercero, tercero_nom, dcmnto, saldo, vence, DATEDIFF(NOW(),vence) AS DIAS_VENCE, cuenta, cuenta_nom FROM saldo_cxp WHERE";

    if (tipo == "CORRIENTE") {
      query = "$query DATEDIFF(NOW(),vence)<=0";
    }
    if (tipo == "1 A 30") {
      query = "$query DATEDIFF(NOW(),vence)>0 AND DATEDIFF(NOW(),vence)<=30";
    }
    if (tipo == "31 A 60") {
      query = "$query DATEDIFF(NOW(),vence)>30 AND DATEDIFF(NOW(),vence)<=60";
    }
    if (tipo == "61 A 90") {
      query = "$query DATEDIFF(NOW(),vence)>60 AND DATEDIFF(NOW(),vence)<=90";
    }
    if (tipo == "91 A 120") {
      query = "$query DATEDIFF(NOW(),vence)>90 AND DATEDIFF(NOW(),vence)<=120";
    }
    if (tipo == "MAYOR 120") {
      query = "$query DATEDIFF(NOW(),vence)>120";
    }
    return "$query ORDER BY DIAS_VENCE DESC LIMIT $size OFFSET ${page * size}";
  }
  return "";
}
