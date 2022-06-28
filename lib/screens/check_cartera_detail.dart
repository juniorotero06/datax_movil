import 'package:datax_movil/helpers/query_sql.dart';
import 'package:datax_movil/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../controllers/controllers.dart';
import '../models/models.dart';
import '../services/services.dart';
import '../themes/app_theme.dart';

class CheckCarteraDetail extends StatelessWidget {
  const CheckCarteraDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final balanceServices = Provider.of<BalanceServices>(context);
    final List<DetailsCartera> dataContent =
        balanceServices.onDisplayDetailsCartera;

    double saldo = 0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Center(child: Text("Resultado de Consulta de Cartera")),
      ),
      body: Background(
          child: SingleChildScrollView(
        child: GetBuilder<ModalCarteraController>(
            init: ModalCarteraController(),
            builder: (_) {
              if (_.vrSaldo != null) {
                saldo = _.vrSaldo.toDouble();
              } else {
                saldo = 0;
              }

              return Column(
                children: [
                  const SizedBox(height: 130),
                  if (dataContent.isEmpty)
                    const Text("No hay Saldos a mostrar",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                  if (!_.isCXPC)
                    Text("Cartera ${_.tipo}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                  if (_.isCXPC)
                    Text("Cartera ${_.clase} ${_.tipo}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                  if (_.cXCEnabled && !_.isCXPC) const SizedBox(height: 30),
                  if (_.cXCEnabled && !_.isCXPC)
                    Center(
                        child: Text(
                            "Total Saldo de Cartera CXC: ${NumberFormat.currency(locale: 'en_us', decimalDigits: 0).format(saldo).replaceAll('USD', '')}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold))),
                  if (_.cxPEnabled && !_.isCXPC) const SizedBox(height: 30),
                  if (_.cxPEnabled && !_.isCXPC)
                    Center(
                        child: Text(
                            "Total Saldo de Cartera CXP: ${NumberFormat.currency(locale: 'en_us', decimalDigits: 0).format(saldo).replaceAll('USD', '')}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold))),
                  const SizedBox(height: 30),
                  if (dataContent.isNotEmpty)
                    _DetailsCarteraDataTable(dataContent: dataContent),
                  const SizedBox(height: 10),
                  const _ButtomsPaginate(),
                  const SizedBox(height: 30),
                ],
              );
            }),
      )),
    );
  }
}

class _DetailsCarteraDataTable extends StatelessWidget {
  const _DetailsCarteraDataTable({
    Key? key,
    required this.dataContent,
  }) : super(key: key);

  final List<DetailsCartera> dataContent;

  @override
  Widget build(BuildContext context) {
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
                DataColumn(label: Center(child: Text("Tercero"))),
                DataColumn(label: Center(child: Text("Nombre"))),
                DataColumn(label: Center(child: Text("Documento"))),
                DataColumn(label: Center(child: Text("Saldo"))),
                DataColumn(label: Center(child: Text("Vence"))),
                DataColumn(label: Center(child: Text("Dias de Vencimiento"))),
                DataColumn(label: Center(child: Text("Cuenta"))),
                DataColumn(label: Center(child: Text("Nombre de Cuenta"))),
              ],
              rows: dataContent
                  .map((index) => DataRow(cells: [
                        DataCell(Center(
                            child: Text(index.tercero ?? "Sin datos básicos"))),
                        DataCell(Text(index.terceroNom ?? "Sin datos básicos")),
                        DataCell(Center(
                            child: Text(index.dcmnto ?? "Sin datos básicos"))),
                        DataCell(Center(
                            child: Text(NumberFormat.currency(
                                    locale: 'en_us', decimalDigits: 0)
                                .format(index.saldo!)
                                .replaceAll('USD', '')))),
                        DataCell(Center(
                            child:
                                Text(index.vence.toString().substring(0, 10)))),
                        DataCell(
                            Center(child: Text(index.diasVence.toString()))),
                        DataCell(Center(
                            child: Text(index.cuenta ?? "Sin datos básicos"))),
                        DataCell(Center(
                            child:
                                Text(index.cuentaNom ?? "Sin datos básicos")))
                      ]))
                  .toList(),
            ),
          )),
    );
  }
}

class _ButtomsPaginate extends StatefulWidget {
  const _ButtomsPaginate({
    Key? key,
  }) : super(key: key);

  @override
  State<_ButtomsPaginate> createState() => _ButtomsPaginateState();
}

class _ButtomsPaginateState extends State<_ButtomsPaginate> {
  int page = 0;
  int size = 10;

  @override
  Widget build(BuildContext context) {
    final balanceServices = Provider.of<BalanceServices>(context);
    final authServices = Provider.of<AuthServices>(context);
    int actualPage = page + 1;

    return FutureBuilder(
      future: authServices.readToken("auth-token"),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        return GetBuilder<ModalCarteraController>(
          init: ModalCarteraController(),
          builder: (_) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () async {
                    if (page >= 1) {
                      page--;

                      if (_.cXCEnabled) {
                        String query = queryDetails_CXPC("CXC", _.tipo, page,
                            size, _.cuenta, _.codTercero, _.nomTercero);

                        await balanceServices.getDetail_CxPC(query,
                            page.toString(), size.toString(), snapshot.data!);
                      }
                      if (_.cxPEnabled) {
                        String query = queryDetails_CXPC("CXP", _.tipo, page,
                            size, _.cuenta, _.codTercero, _.nomTercero);

                        await balanceServices.getDetail_CxPC(query,
                            page.toString(), size.toString(), snapshot.data!);
                      }

                      if (_.isCXPC) {
                        String query = queryDetails_CXPC(_.clase, _.tipo, page,
                            size, _.cuenta, _.codTercero, _.nomTercero);

                        await balanceServices.getDetail_CxPC(query,
                            page.toString(), size.toString(), snapshot.data!);
                      }
                      setState(() {});
                    }
                  },
                  icon: const Icon(Icons.arrow_back_ios_new,
                      color: AppTheme.primary)),
              Text(
                "$actualPage | ${balanceServices.totalPages.toString()}",
                style: const TextStyle(fontSize: 20),
              ),
              IconButton(
                  color: AppTheme.primary,
                  onPressed: () async {
                    if (page < balanceServices.totalPages) {
                      page++;

                      if (_.cXCEnabled) {
                        String query = queryDetails_CXPC("CXC", _.tipo, page,
                            size, _.cuenta, _.codTercero, _.nomTercero);

                        await balanceServices.getDetail_CxPC(query,
                            page.toString(), size.toString(), snapshot.data!);
                      }
                      if (_.cxPEnabled) {
                        String query = queryDetails_CXPC("CXP", _.tipo, page,
                            size, _.cuenta, _.codTercero, _.nomTercero);

                        await balanceServices.getDetail_CxPC(query,
                            page.toString(), size.toString(), snapshot.data!);
                      }

                      if (_.isCXPC) {
                        String query = queryDetails_CXPC(_.clase, _.tipo, page,
                            size, _.cuenta, _.codTercero, _.nomTercero);

                        await balanceServices.getDetail_CxPC(query,
                            page.toString(), size.toString(), snapshot.data!);
                      }
                      setState(() {});
                    }
                  },
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    color: AppTheme.primary,
                  ))
            ],
          ),
        );
      },
    );
  }
}
