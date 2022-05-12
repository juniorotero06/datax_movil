import 'package:datax_movil/themes/app_theme.dart';
import 'package:datax_movil/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../models/models.dart';
import '../services/services.dart';

class CheckBalanceScreen extends StatelessWidget {
  static const String routerName = "check_balance";
  final String? endpoint;
  final String? body;

  const CheckBalanceScreen({Key? key, this.endpoint, this.body})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final balanceServices = Provider.of<BalanceServices>(context);
    final List<Saldos> dataContent = balanceServices.onDisplaySaldos;
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.primary,
          title: const Center(child: Text("Tabla de Saldos")),
        ),
        body: Background(
          child: Column(
            children: [
              const SizedBox(height: 130),
              _SaldosDataTable(dataContent: dataContent),
              const SizedBox(height: 10),
              _ButtomsPaginate(
                body: args.body,
                endpoint: args.endpoint,
              )
            ],
          ),
        ));
  }
}

class _SaldosDataTable extends StatelessWidget {
  const _SaldosDataTable({
    Key? key,
    required this.dataContent,
  }) : super(key: key);

  final List<Saldos> dataContent;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          dataRowColor: MaterialStateColor.resolveWith(
              (states) => const Color.fromRGBO(255, 255, 255, 0.4)),
          headingRowColor: MaterialStateColor.resolveWith(
              (states) => const Color.fromRGBO(145, 145, 145, 0.3)),
          columnSpacing: 15,
          columns: const [
            DataColumn(label: Text("Código de Saldo")),
            DataColumn(label: Text("Saldo Actual")),
            DataColumn(label: Text("Nombre del Producto")),
            DataColumn(label: Text("Nombre de Bodega")),
            DataColumn(label: Text("Línea")),
          ],
          rows: dataContent
              .map((index) => DataRow(cells: [
                    DataCell(Center(child: Text(index.codSdo))),
                    DataCell(Center(child: Text(index.actualSdo.toString()))),
                    DataCell(Text(index.descrip)),
                    DataCell(Center(child: Text(index.desBod))),
                    DataCell(Center(child: Text(index.desLinea)))
                  ]))
              .toList(),
        ));
  }
}

class _ButtomsPaginate extends StatefulWidget {
  final String endpoint;
  final String body;
  const _ButtomsPaginate({
    Key? key,
    required this.endpoint,
    required this.body,
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
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () async {
                  if (page >= 1) {
                    page--;

                    if (widget.endpoint == "bodega") {
                      await balanceServices.getBodega(widget.body,
                          page.toString(), size.toString(), snapshot.data!);
                    }
                    if (widget.endpoint == "codsaldo") {
                      await balanceServices.getCodSaldo(widget.body,
                          page.toString(), size.toString(), snapshot.data!);
                    }
                    if (widget.endpoint == "linea") {
                      await balanceServices.getLinea(widget.body,
                          page.toString(), size.toString(), snapshot.data!);
                    }
                    if (widget.endpoint == "producto") {
                      await balanceServices.getProducto(widget.body,
                          page.toString(), size.toString(), snapshot.data!);
                    }
                    if (widget.endpoint == "saldo") {
                      await balanceServices.getSaldo(widget.body,
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

                    if (widget.endpoint == "bodega") {
                      await balanceServices.getBodega(widget.body,
                          page.toString(), size.toString(), snapshot.data!);
                    }
                    if (widget.endpoint == "codsaldo") {
                      await balanceServices.getCodSaldo(widget.body,
                          page.toString(), size.toString(), snapshot.data!);
                    }
                    if (widget.endpoint == "linea") {
                      await balanceServices.getLinea(widget.body,
                          page.toString(), size.toString(), snapshot.data!);
                    }
                    if (widget.endpoint == "producto") {
                      await balanceServices.getProducto(widget.body,
                          page.toString(), size.toString(), snapshot.data!);
                    }
                    if (widget.endpoint == "saldo") {
                      await balanceServices.getSaldo(widget.body,
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
        );
      },
    );
  }
}
