import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:datax_movil/controllers/controllers.dart';
import 'package:datax_movil/helpers/query_sql.dart';
import 'package:datax_movil/models/models.dart';
import 'package:datax_movil/screens/screens.dart';
import 'package:datax_movil/widgets/widgets.dart';

import '../services/services.dart';
import '../themes/app_theme.dart';

class CheckCarteraScreen extends StatelessWidget {
  const CheckCarteraScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final balanceServices = Provider.of<BalanceServices>(context);

    List<Cartera> listCarteraCXC = balanceServices.onDisplayCartera;
    List<Cartera> listCarteraCXP = balanceServices.onDisplayCartera;
    final List<CarteraCXPC> listCarteraCXPC =
        balanceServices.onDisplayCarteraCXPX;
    double totalCarteraCXC = 0;
    double totalcarteraCXP = 0;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Center(child: Text("Resultado de Consulta de Cartera")),
      ),
      body: Background(
          child: GetBuilder<CheckCarteraController>(
        init: CheckCarteraController(),
        builder: (_) => Center(
          child: SingleChildScrollView(
            child: GetBuilder<ModalCarteraController>(
                init: ModalCarteraController(),
                builder: (__) {
                  if (__.cXCEnabled && !__.isCXPC) {
                    for (int i = 0; i < listCarteraCXC.length; i++) {
                      totalCarteraCXC = totalCarteraCXC +
                          listCarteraCXC[i].vrSaldo!.toDouble();
                    }
                  }
                  if (__.cxPEnabled && !__.isCXPC) {
                    for (int i = 0; i < listCarteraCXP.length; i++) {
                      totalcarteraCXP = totalcarteraCXP +
                          listCarteraCXP[i].vrSaldo!.toDouble();
                    }
                  }

                  if (__.isCXPC) {
                    for (int i = 0; i < listCarteraCXPC.length; i++) {
                      if (listCarteraCXPC[i].clase == "CXC") {
                        totalCarteraCXC =
                            totalCarteraCXC + listCarteraCXPC[i].vrSaldo!;
                      }
                      if (listCarteraCXPC[i].clase == "CXP") {
                        totalcarteraCXP =
                            totalcarteraCXP + listCarteraCXPC[i].vrSaldo!;
                      }
                    }
                  }

                  return Column(
                    children: [
                      const SizedBox(height: 80),
                      if (__.cXCEnabled && !__.isCXPC)
                        const Center(
                            child: Text("Cuentas Por Cobrar",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold))),
                      if (__.cxPEnabled && !__.isCXPC)
                        const Center(
                            child: Text("Cuentas Por Pagar",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold))),
                      const SizedBox(height: 20),
                      if (!_.isCXPC) const _DataTableCartera(),
                      if (__.cXCEnabled && !__.isCXPC)
                        const SizedBox(height: 30),
                      if (__.cXCEnabled && !__.isCXPC)
                        Center(
                            child: Text(
                                "Total Saldo de Cartera CXC: ${NumberFormat.currency(locale: 'en_us', decimalDigits: 0).format(totalCarteraCXC)}"
                                    .replaceAll('USD', ''),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold))),
                      if (__.cxPEnabled && !__.isCXPC)
                        const SizedBox(height: 30),
                      if (__.cxPEnabled && !__.isCXPC)
                        Center(
                            child: Text(
                                "Total Saldo de Cartera CXP: ${NumberFormat.currency(locale: 'en_us', decimalDigits: 0).format(totalcarteraCXP)}"
                                    .replaceAll('USD', ''),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold))),
                      if (_.isCXPC) const _DataTableCarteraCXCP(),
                      if (_.isCXPC) const SizedBox(height: 30),
                      if (_.isCXPC)
                        Center(
                            child: Text(
                                "Total CXC: ${NumberFormat.currency(locale: 'en_us', decimalDigits: 0).format(totalCarteraCXC).replaceAll('USD', '')} Vs. Total CXP: ${NumberFormat.currency(locale: 'en_us', decimalDigits: 0).format(totalcarteraCXP).replaceAll('USD', '')}",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold))),
                      const SizedBox(height: 30),
                      if (_.isCXPC) const _ButtonGraphic(),
                      const SizedBox(height: 30),
                    ],
                  );
                }),
          ),
        ),
      )),
    );
  }
}

class _ButtonGraphic extends StatelessWidget {
  const _ButtonGraphic({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        disabledColor: Colors.grey,
        elevation: 0,
        color: AppTheme.primary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: const Text(
                "Generar Gráfica",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            const Icon(Icons.auto_graph, color: Colors.white, size: 30),
          ],
        ),
        onPressed: () {});
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
            builder: (_) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Center(
                  child: DataTable(
                      dataRowColor: MaterialStateColor.resolveWith(
                          (states) => const Color.fromRGBO(255, 255, 255, 0.4)),
                      headingRowColor: MaterialStateColor.resolveWith(
                          (states) => const Color.fromRGBO(145, 145, 145, 0.3)),
                      columnSpacing: 15,
                      columns: const [
                        DataColumn(
                            label: Center(
                                child: Text("Clase",
                                    textAlign: TextAlign.center))),
                        DataColumn(
                            label: Center(
                                child:
                                    Text("Tipo", textAlign: TextAlign.center))),
                        DataColumn(
                            label: Center(
                                child: Text("Documentos",
                                    textAlign: TextAlign.center))),
                        DataColumn(
                            label: Center(
                                child: Text("Valor de Saldo",
                                    textAlign: TextAlign.center))),
                        DataColumn(
                            label: Center(
                                child:
                                    Text("Ver", textAlign: TextAlign.center))),
                      ],
                      rows: dataContent
                          .map((index) => DataRow(cells: [
                                DataCell(Center(
                                    child: Text(
                                  index.clase ?? "Sin datos básicos",
                                  textAlign: TextAlign.center,
                                ))),
                                DataCell(Center(
                                    child: Text(
                                        index.tipo ?? "Sin datos básicos",
                                        textAlign: TextAlign.center))),
                                DataCell(Center(
                                    child: Text(index.documentos.toString(),
                                        textAlign: TextAlign.center))),
                                DataCell(Center(
                                    child: Text(
                                        NumberFormat.currency(
                                                locale: 'en_us',
                                                decimalDigits: 0)
                                            .format(index.vrSaldo!)
                                            .replaceAll('USD', ''),
                                        textAlign: TextAlign.center))),
                                DataCell(Center(
                                  child: IconButton(
                                    icon: const Icon(Icons.search),
                                    onPressed: () async {
                                      _.clase = index.clase!;
                                      _.tipo = index.tipo!;
                                      _.vrSaldo = index.vrSaldo!;
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
                ),
              ),
            ),
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
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Center(
                  child: DataTable(
                      dataRowColor: MaterialStateColor.resolveWith(
                          (states) => const Color.fromRGBO(255, 255, 255, 0.4)),
                      headingRowColor: MaterialStateColor.resolveWith(
                          (states) => const Color.fromRGBO(145, 145, 145, 0.3)),
                      columnSpacing: 15,
                      columns: const [
                        DataColumn(
                            label: Center(
                                child:
                                    Text("Tipo", textAlign: TextAlign.center))),
                        DataColumn(
                            label: Center(
                                child: Text("Documentos",
                                    textAlign: TextAlign.center))),
                        DataColumn(
                            label: Center(
                                child: Text("Valor de Saldo",
                                    textAlign: TextAlign.center))),
                        DataColumn(
                            label: Center(
                                child:
                                    Text("Ver", textAlign: TextAlign.center))),
                      ],
                      rows: dataContent
                          .map((index) => DataRow(cells: [
                                DataCell(Center(
                                    child: Text(
                                        index.tipo ?? "Sin datos básicos",
                                        textAlign: TextAlign.center))),
                                DataCell(Center(
                                    child: Text(index.documentos.toString(),
                                        textAlign: TextAlign.center))),
                                DataCell(Center(
                                    child: Text(
                                        NumberFormat.currency(
                                                locale: 'en_us',
                                                decimalDigits: 0)
                                            .format(index.vrSaldo!)
                                            .replaceAll('USD', ''),
                                        textAlign: TextAlign.center))),
                                DataCell(Center(
                                  child: IconButton(
                                    icon: const Icon(Icons.search),
                                    onPressed: () async {
                                      if (_.cXCEnabled) {
                                        _.tipo = index.tipo!;
                                        _.vrSaldo = index.vrSaldo!;
                                        String query = queryDetails_CXPC(
                                            "CXC", index.tipo!, 0, 10);
                                        print(query);
                                        await balanceServices.getDetail_CxPC(
                                            query, "0", "10", snapshot.data!);
                                        await Get.to(
                                            const CheckCarteraDetail());
                                      }
                                      if (_.cxPEnabled) {
                                        _.tipo = index.tipo!;
                                        String query = queryDetails_CXPC(
                                            "CXP", index.tipo!, 0, 10);
                                        print(query);
                                        await balanceServices.getDetail_CxPC(
                                            query, "0", "10", snapshot.data!);
                                        await Get.to(
                                            const CheckCarteraDetail());
                                      }
                                    },
                                  ),
                                ))
                              ]))
                          .toList()),
                ),
              ),
            );
          }),
    );
  }
}
