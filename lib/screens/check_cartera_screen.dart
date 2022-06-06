import 'package:datax_movil/controllers/check_cartera_controller.dart';
import 'package:datax_movil/controllers/controllers.dart';
import 'package:datax_movil/helpers/query_sql.dart';
import 'package:datax_movil/models/models.dart';
import 'package:datax_movil/screens/check_cartera_detail.dart';
import 'package:datax_movil/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
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
        builder: (_) => Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                if (!_.isCXPC) const _DataTableCartera(),
                if (_.isCXPC) const _DataTableCarteraCXCP(),
                // const SizedBox(height: 30),
                // if (_.isCXPC)
                //   MaterialButton(
                //       shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(10)),
                //       disabledColor: Colors.grey,
                //       elevation: 0,
                //       color: AppTheme.primary,
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         mainAxisSize: MainAxisSize.min,
                //         children: [
                //           Container(
                //             padding: const EdgeInsets.symmetric(
                //                 horizontal: 10, vertical: 20),
                //             child: const Text(
                //               "Generar Gráfica",
                //               style:
                //                   TextStyle(color: Colors.white, fontSize: 20),
                //             ),
                //           ),
                //           const Icon(Icons.auto_graph,
                //               color: Colors.white, size: 30),
                //         ],
                //       ),
                //       onPressed: () {}),
                const SizedBox(height: 30),
              ],
            ),
          ),
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
    final authServices = Provider.of<AuthServices>(context);
    final List<CarteraCXPC> dataContent = balanceServices.onDisplayCarteraCXPX;
    return FutureBuilder(
        future: authServices.readToken("auth-token"),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return GetBuilder<ModalCarteraController>(
            init: ModalCarteraController(),
            builder: (_) => DataTable(
                dataRowColor: MaterialStateColor.resolveWith(
                    (states) => const Color.fromRGBO(255, 255, 255, 0.4)),
                headingRowColor: MaterialStateColor.resolveWith(
                    (states) => const Color.fromRGBO(145, 145, 145, 0.3)),
                columnSpacing: 15,
                columns: const [
                  DataColumn(label: Center(child: Text("Clase"))),
                  DataColumn(label: Center(child: Text("Tipo"))),
                  DataColumn(label: Center(child: Text("Documentos"))),
                  DataColumn(label: Center(child: Text("Valor de Saldo"))),
                  DataColumn(label: Center(child: Text("Ver"))),
                ],
                rows: dataContent
                    .map((index) => DataRow(cells: [
                          DataCell(Center(child: Text(index.clase ?? ""))),
                          DataCell(Center(child: Text(index.tipo ?? ""))),
                          DataCell(
                              Center(child: Text(index.documentos.toString()))),
                          DataCell(
                              Center(child: Text(index.vrSaldo.toString()))),
                          DataCell(Center(
                            child: IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () async {
                                _.clase = index.clase!;
                                _.tipo = index.tipo!;
                                _.limpiar();
                                String query = queryDetails_CXPC(
                                    index.clase!, index.tipo!, 0, 10);
                                print(query);
                                await balanceServices.getDetail_CxPC(
                                    query, "0", "10", snapshot.data!);
                                await Get.to(const CheckCarteraDetail());
                              },
                            ),
                          ))
                        ]))
                    .toList()),
          );
        });
  }
}

class _DataTableCartera extends StatelessWidget {
  const _DataTableCartera({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final balanceServices = Provider.of<BalanceServices>(context);
    final authServices = Provider.of<AuthServices>(context);
    final List<Cartera> dataContent = balanceServices.onDisplayCartera;

    return GetBuilder<ModalCarteraController>(
      init: ModalCarteraController(),
      builder: (_) => FutureBuilder(
        future: authServices.readToken("auth-token"),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) =>
            DataTable(
                dataRowColor: MaterialStateColor.resolveWith(
                    (states) => const Color.fromRGBO(255, 255, 255, 0.4)),
                headingRowColor: MaterialStateColor.resolveWith(
                    (states) => const Color.fromRGBO(145, 145, 145, 0.3)),
                columnSpacing: 15,
                columns: const [
                  DataColumn(label: Center(child: Text("Tipo"))),
                  DataColumn(label: Center(child: Text("Documentos"))),
                  DataColumn(label: Center(child: Text("Valor de Saldo"))),
                  DataColumn(label: Center(child: Text("Ver"))),
                ],
                rows: dataContent
                    .map((index) => DataRow(cells: [
                          DataCell(Center(child: Text(index.tipo ?? ""))),
                          DataCell(
                              Center(child: Text(index.documentos.toString()))),
                          DataCell(
                              Center(child: Text(index.vrSaldo.toString()))),
                          DataCell(Center(
                            child: IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () async {
                                if (_.cXCEnabled) {
                                  _.tipo = index.tipo!;
                                  String query = queryDetails_CXPC(
                                      "CXC", index.tipo!, 0, 10);
                                  print(query);
                                  await balanceServices.getDetail_CxPC(
                                      query, "0", "10", snapshot.data!);
                                  await Get.to(const CheckCarteraDetail());
                                }
                                if (_.cxPEnabled) {
                                  _.tipo = index.tipo!;
                                  String query = queryDetails_CXPC(
                                      "CXP", index.tipo!, 0, 10);
                                  print(query);
                                  await balanceServices.getDetail_CxPC(
                                      query, "0", "10", snapshot.data!);
                                  await Get.to(const CheckCarteraDetail());
                                }
                              },
                            ),
                          ))
                        ]))
                    .toList()),
      ),
    );
  }
}
