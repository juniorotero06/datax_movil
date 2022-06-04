import 'package:datax_movil/themes/app_theme.dart';
import 'package:datax_movil/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/query_sql.dart';
import '../main.dart';
import '../models/models.dart';
import '../services/services.dart';

class CheckBalanceScreenWithGrupos extends StatelessWidget {
  static const String routerName = "check_balance_grupo";
  final String? bodega;
  final String? producto;
  final String? codProducto;
  final String? grupo;
  final String? linea;
  final String? saldo;

  const CheckBalanceScreenWithGrupos(
      {Key? key,
      this.bodega,
      this.producto,
      this.codProducto,
      this.grupo,
      this.linea,
      this.saldo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final balanceServices = Provider.of<BalanceServices>(context);
    final List<SaldosWithGrupo> dataContent =
        balanceServices.onDisplaySaldosWithGrupo;
    final args =
        ModalRoute.of(context)!.settings.arguments as ScreenArgumentsFilter;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.primary,
          title: const Center(child: Text("Resultado de Consulta")),
        ),
        body: Background(
          child: Column(
            children: [
              const SizedBox(height: 130),
              if (dataContent.isEmpty)
                const Text("No hay Saldos a mostrar",
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              if (dataContent.isNotEmpty)
                _SaldosDataTable(dataContent: dataContent),
              const SizedBox(height: 10),
              _ButtomsPaginate(
                bodega: args.bodega,
                codProducto: args.codProducto,
                grupo: args.grupo,
                linea: args.linea,
                producto: args.producto,
                saldo: args.saldo,
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

  final List<SaldosWithGrupo> dataContent;

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
            DataColumn(label: Text("Grupo")),
          ],
          rows: dataContent
              .map((index) => DataRow(cells: [
                    DataCell(Center(child: Text(index.codSdo ?? ""))),
                    DataCell(Center(child: Text(index.actualSdo.toString()))),
                    DataCell(Text(index.descrip ?? "")),
                    DataCell(Center(child: Text(index.desBod ?? ""))),
                    DataCell(Center(child: Text(index.desLinea ?? ""))),
                    DataCell(Text(index.descGru ?? "")),
                  ]))
              .toList(),
        ));
  }
}

class _ButtomsPaginate extends StatefulWidget {
  final String bodega;
  final String producto;
  final String codProducto;
  final String grupo;
  final String linea;
  final String saldo;
  const _ButtomsPaginate({
    Key? key,
    required this.bodega,
    required this.producto,
    required this.codProducto,
    required this.grupo,
    required this.linea,
    required this.saldo,
  }) : super(key: key);

  @override
  State<_ButtomsPaginate> createState() => _ButtomsPaginateState();
}

class _ButtomsPaginateState extends State<_ButtomsPaginate> {
  int page = 0;
  int size = 15;

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

                    String query = querySQL(
                        widget.codProducto,
                        widget.producto,
                        widget.bodega,
                        widget.linea,
                        widget.grupo,
                        widget.saldo,
                        page,
                        size);

                    await balanceServices.getSaldosByFilters(query,
                        page.toString(), size.toString(), snapshot.data!);

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

                    String query = querySQL(
                        widget.codProducto,
                        widget.producto,
                        widget.bodega,
                        widget.linea,
                        widget.grupo,
                        widget.saldo,
                        page,
                        size);

                    await balanceServices.getSaldosByFilters(query,
                        page.toString(), size.toString(), snapshot.data!);
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
