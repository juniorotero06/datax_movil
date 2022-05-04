import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../services/services.dart';

class CheckBalanceScreen extends StatelessWidget {
  static const String routerName = "check_balance";
  const CheckBalanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final balanceServices = Provider.of<BalanceServices>(context);
    final List<Saldos> dataContent = balanceServices.onDisplaySaldos;

    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("Tabla de Saldos")),
        ),
        body: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
                columnSpacing: 15,
                columns: const [
                  DataColumn(label: Text("Nombre de Bodega")),
                  DataColumn(label: Text("Código de Saldo")),
                  DataColumn(label: Text("Nombre del Producto")),
                  DataColumn(label: Text("Saldo Actual")),
                  DataColumn(label: Text("Línea")),
                ],
                rows: dataContent
                    .map((index) => DataRow(cells: [
                          DataCell(Center(child: Text(index.desBod))),
                          DataCell(Center(child: Text(index.codSdo))),
                          DataCell(Center(child: Text(index.descrip))),
                          DataCell(
                              Center(child: Text(index.actualSdo.toString()))),
                          DataCell(Center(child: Text(index.desLinea)))
                        ]))
                    .toList())));
  }
}
