String querySQL(String codProducto, String producto, String bodega,
    String linea, String grupo, String saldos, int page, int size) {
  var desGrupo;

  String query =
      "SELECT a.des_bod, b.cod_sdo, c.descrip, b.actual_sdo, d.des_linea, e.desc_gru FROM insaldo as b JOIN inbodega as a JOIN initem as c on c.cod_item = b.cod_sdo JOIN inlinea as d on c.itm_linea = d.cod_linea JOIN ingrupo as e WHERE";

  if (codProducto != "") {
    query = "$query c.cod_item LIKE '%$codProducto%'";
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
    query = "$query d.des_linea LIKE '%$linea%'";
  }

  if (grupo != "") {
    if (codProducto != "" || producto != "" || bodega != "" || linea != "") {
      query = "$query AND";
    }
    desGrupo = grupo.split("-");
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
