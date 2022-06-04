import 'package:datax_movil/helpers/query_sql.dart';
import 'package:datax_movil/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Center(child: Text("Resultado de Consulta")),
      ),
      body: Background(
          child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 130),
            if (dataContent.isEmpty)
              const Text("No hay Saldos a mostrar",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            if (dataContent.isNotEmpty)
              _DetailsCarteraDataTable(dataContent: dataContent),
            const SizedBox(height: 10),
            const _ButtomsPaginate(),
            const SizedBox(height: 30),
          ],
        ),
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
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Center(
          child: DataTable(
            dataRowColor: MaterialStateColor.resolveWith(
                (states) => const Color.fromRGBO(255, 255, 255, 0.4)),
            headingRowColor: MaterialStateColor.resolveWith(
                (states) => const Color.fromRGBO(145, 145, 145, 0.3)),
            columnSpacing: 15,
            columns: const [
              DataColumn(label: Text("Tercero")),
              DataColumn(label: Text("Nombre")),
              DataColumn(label: Text("Documento")),
              DataColumn(label: Text("Saldo")),
              DataColumn(label: Text("Vence")),
              DataColumn(label: Text("Dias de Vencimiento")),
            ],
            rows: dataContent
                .map((index) => DataRow(cells: [
                      DataCell(Center(child: Text(index.tercero ?? ""))),
                      DataCell(Text(index.terceroNom ?? "")),
                      DataCell(Center(child: Text(index.dcmnto ?? ""))),
                      DataCell(Center(child: Text(index.saldo.toString()))),
                      DataCell(Center(child: Text(index.vence.toString()))),
                      DataCell(Center(child: Text(index.diasVence.toString()))),
                    ]))
                .toList(),
          ),
        ));
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
                      print("Clase: ${_.clase}");

                      if (_.cXCEnabled) {
                        print("Clase: ENTRE CXC");
                        String query =
                            queryDetails_CXPC("CXC", _.tipo, page, size);

                        await balanceServices.getDetail_CxPC(query,
                            page.toString(), size.toString(), snapshot.data!);
                      }
                      if (_.cxPEnabled) {
                        print("Clase: ENTRE CXP");
                        String query =
                            queryDetails_CXPC("CXP", _.tipo, page, size);

                        await balanceServices.getDetail_CxPC(query,
                            page.toString(), size.toString(), snapshot.data!);
                      }

                      if (_.isCXPC) {
                        print("Clase: ENTRE CXP y CXC");
                        String query =
                            queryDetails_CXPC(_.clase, _.tipo, page, size);

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
                      print("Clase: ${_.clase}");
                      if (_.cXCEnabled) {
                        print("Clase: ENTRE CXC");
                        String query =
                            queryDetails_CXPC("CXC", _.tipo, page, size);

                        await balanceServices.getDetail_CxPC(query,
                            page.toString(), size.toString(), snapshot.data!);
                      }
                      if (_.cxPEnabled) {
                        print("Clase: ENTRE CXP");
                        String query =
                            queryDetails_CXPC("CXP", _.tipo, page, size);

                        await balanceServices.getDetail_CxPC(query,
                            page.toString(), size.toString(), snapshot.data!);
                      }

                      if (_.isCXPC) {
                        print("Clase: ENTRE CXP y CXC");
                        String query =
                            queryDetails_CXPC(_.clase, _.tipo, page, size);

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
