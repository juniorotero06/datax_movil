import 'package:datax_movil/controllers/check_cartera_controller.dart';
import 'package:datax_movil/models/models.dart';
import 'package:datax_movil/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:provider/provider.dart';

import '../services/services.dart';
import '../themes/app_theme.dart';

class CheckCarteraScreen extends StatelessWidget {
  const CheckCarteraScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Center(child: Text("Resultado de Consulta")),
      ),
      body: Background(
          child: GetBuilder<CheckCarteraController>(
        init: CheckCarteraController(),
        builder: (_) => Column(
          children: [
            if (!_.isCXPC) const _DataTableCartera(),
            if (_.isCXPC) const _DataTableCarteraCXCP()
          ],
        ),
      )),
    );
  }
}

class _DataTableCarteraCXCP extends StatelessWidget {
  const _DataTableCarteraCXCP({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final balanceServices = Provider.of<BalanceServices>(context);
    final List<CarteraCXPC> dataContent = balanceServices.onDisplayCarteraCXPX;
    return DataTable(
        dataRowColor: MaterialStateColor.resolveWith(
            (states) => const Color.fromRGBO(255, 255, 255, 0.4)),
        headingRowColor: MaterialStateColor.resolveWith(
            (states) => const Color.fromRGBO(145, 145, 145, 0.3)),
        columnSpacing: 15,
        columns: const [
          DataColumn(label: Text("Clase")),
          DataColumn(label: Text("Tipo")),
          DataColumn(label: Text("Documentos")),
          DataColumn(label: Text("Valor de Saldo")),
        ],
        rows: dataContent
            .map((index) => DataRow(cells: [
                  DataCell(Text(index.clase ?? "")),
                  DataCell(Text(index.tipo ?? "")),
                  DataCell(Text(index.documentos.toString())),
                  DataCell(Text(index.vrSaldo.toString())),
                ]))
            .toList());
  }
}

class _DataTableCartera extends StatelessWidget {
  const _DataTableCartera({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final balanceServices = Provider.of<BalanceServices>(context);

    final List<Cartera> dataContent = balanceServices.onDisplayCartera;

    return DataTable(
        dataRowColor: MaterialStateColor.resolveWith(
            (states) => const Color.fromRGBO(255, 255, 255, 0.4)),
        headingRowColor: MaterialStateColor.resolveWith(
            (states) => const Color.fromRGBO(145, 145, 145, 0.3)),
        columnSpacing: 15,
        columns: const [
          DataColumn(label: Text("Tipo")),
          DataColumn(label: Text("Documentos")),
          DataColumn(label: Text("Valor de Saldo")),
        ],
        rows: dataContent
            .map((index) => DataRow(cells: [
                  DataCell(Text(index.tipo ?? "")),
                  DataCell(Text(index.documentos.toString())),
                  DataCell(Text(index.vrSaldo.toString())),
                ]))
            .toList());
  }
}
