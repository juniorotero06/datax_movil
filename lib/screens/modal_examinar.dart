import 'package:datax_movil/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:provider/provider.dart';

import '../controllers/controllers.dart';
import '../services/services.dart';

class ModalExaminar extends StatelessWidget {
  const ModalExaminar({Key? key, this.title, this.endpoint}) : super(key: key);

  final String? title;
  final String? endpoint;

  @override
  Widget build(BuildContext context) {
    final auxiliarServices = Provider.of<AuxiliarServices>(context);

    return Scaffold(
        body: Background(
      child: GetBuilder<ModalHomeController>(
          init: ModalHomeController(),
          builder: (_) => GetBuilder<ModalExaminarController>(
              init: ModalExaminarController(),
              builder: (__) {
                if (__.endpoint == "bodega") {
                  return AlertDialog(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusDirectional.circular(10)),
                      title: Text(title ?? ""),
                      content: Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: DataTable(
                                dataRowColor: MaterialStateColor.resolveWith(
                                    (states) => const Color.fromRGBO(
                                        255, 255, 255, 0.4)),
                                headingRowColor: MaterialStateColor.resolveWith(
                                    (states) => const Color.fromRGBO(
                                        145, 145, 145, 0.3)),
                                columnSpacing: 10,
                                columns: const [
                                  DataColumn(label: Text("Código")),
                                  DataColumn(label: Text("Descripción")),
                                ],
                                rows: auxiliarServices.onDisplayBodegas
                                    .map((index) => DataRow(cells: [
                                          DataCell(
                                              Center(child: Text(index.codBod)),
                                              onTap: () async {
                                            __.onInputChangedTextBodega(
                                                index.desBod);
                                            // Navigator.pop(context);
                                          }),
                                          DataCell(
                                              Center(child: Text(index.desBod)),
                                              onTap: () async {
                                            //_.bodega = index.desBod;
                                            __.onInputChangedTextBodega(
                                                index.desBod);
                                            //Navigator.pop(context);
                                          }),
                                        ]))
                                    .toList(),
                              ),
                            ),
                          ),
                          TextButton(
                              onPressed: () async {
                                Get.back();
                              },
                              child: const Text("Cancelar")),
                        ],
                      ));
                }

                if (__.endpoint == "linea") {
                  return AlertDialog(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusDirectional.circular(10)),
                      title: Text(title ?? ""),
                      content: Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: DataTable(
                                dataRowColor: MaterialStateColor.resolveWith(
                                    (states) => const Color.fromRGBO(
                                        255, 255, 255, 0.4)),
                                headingRowColor: MaterialStateColor.resolveWith(
                                    (states) => const Color.fromRGBO(
                                        145, 145, 145, 0.3)),
                                columnSpacing: 10,
                                columns: const [
                                  DataColumn(label: Text("Código")),
                                  DataColumn(label: Text("Descripción")),
                                ],
                                rows: auxiliarServices.onDisplayLineas
                                    .map((index) => DataRow(cells: [
                                          DataCell(
                                              Center(
                                                  child: Text(index.codLinea)),
                                              onTap: () async {
                                            __.onInputChangedTextLinea(
                                                "${index.codLinea}||${index.desLinea}");
                                            // Navigator.pop(context);
                                          }),
                                          DataCell(
                                              Center(
                                                  child: Text(index.desLinea)),
                                              onTap: () async {
                                            //_.bodega = index.desBod;
                                            __.onInputChangedTextLinea(
                                                "${index.codLinea}||${index.desLinea}");
                                            //Navigator.pop(context);
                                          }),
                                        ]))
                                    .toList(),
                              ),
                            ),
                          ),
                          TextButton(
                              onPressed: () async {
                                Get.back();
                              },
                              child: const Text("Cancelar")),
                        ],
                      ));
                }
                if (__.endpoint == "grupo") {
                  return AlertDialog(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusDirectional.circular(10)),
                      title: Text(title ?? ""),
                      content: Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: DataTable(
                                dataRowColor: MaterialStateColor.resolveWith(
                                    (states) => const Color.fromRGBO(
                                        255, 255, 255, 0.4)),
                                headingRowColor: MaterialStateColor.resolveWith(
                                    (states) => const Color.fromRGBO(
                                        145, 145, 145, 0.3)),
                                columnSpacing: 15,
                                columns: const [
                                  DataColumn(label: Text("Tipo")),
                                  DataColumn(label: Text("Código")),
                                  DataColumn(label: Text("Descripción")),
                                ],
                                rows: auxiliarServices.onDisplayGrupo
                                    .map((index) => DataRow(cells: [
                                          DataCell(
                                              Center(
                                                  child: Text(index.tipoGru)),
                                              onTap: () async {
                                            __.onInputChangedTextGrupo(
                                                "${index.tipoGru}${index.codigoGru}||${index.descGru}"
                                                    .trim());
                                          }),
                                          DataCell(
                                              Center(
                                                  child: Text(index.codigoGru
                                                      .toString())),
                                              onTap: () async {
                                            __.onInputChangedTextGrupo(
                                                "${index.tipoGru}${index.codigoGru}||${index.descGru}"
                                                    .trim());
                                          }),
                                          DataCell(
                                              Center(
                                                  child: Text(index.descGru)),
                                              onTap: () async {
                                            __.onInputChangedTextGrupo(
                                                "${index.tipoGru}${index.codigoGru}||${index.descGru}"
                                                    .trim());
                                          }),
                                        ]))
                                    .toList(),
                              ),
                            ),
                          ),
                          TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancelar")),
                        ],
                      ));
                }

                return Container();
              })),
    ));
  }
}
