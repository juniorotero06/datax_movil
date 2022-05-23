import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import 'package:datax_movil/services/services.dart';

import '../helpers/query_sql.dart';
import '../main.dart';
import '../models/models.dart';
import '../provider/search_balance_form_provider.dart';
import '../screens/screens.dart';
import '../themes/app_theme.dart';
import '../ui/input_decoration.dart';

void displayModal(BuildContext context, String title, String token) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => SearchBalanceFormProvider()),
          ],
          child: _ModalForm(title: title, token: token),
        );
      });
}

class _ModalForm extends StatelessWidget {
  const _ModalForm({
    Key? key,
    required this.title,
    required this.token,
  }) : super(key: key);

  final String title;
  final String token;

  @override
  Widget build(BuildContext context) {
    final inputSearch = Provider.of<SearchBalanceFormProvider>(context);
    final balanceServices = Provider.of<BalanceServices>(context);
    final authServices = Provider.of<AuthServices>(context);
    const storage = FlutterSecureStorage();
    return AlertDialog(
      elevation: 5,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.circular(10)),
      title: Text(title),
      content: Form(
        key: inputSearch.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  decoration: InputDecorations.authInputDecoration(
                      hint: "",
                      label: "Codigo del Producto",
                      icon: Icons.search),
                  onChanged: (value) {
                    inputSearch.codProducto = value;
                  },
                  validator: (value) {
                    return (value != null)
                        ? null
                        : "El campo no puede estar vacío";
                  }),
              const SizedBox(height: 10),
              TextFormField(
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  decoration: InputDecorations.authInputDecoration(
                      hint: "",
                      label: "Nombre de Producto",
                      icon: Icons.search),
                  onChanged: (value) {
                    inputSearch.producto = value;
                  },
                  validator: (value) {
                    return (value != null)
                        ? null
                        : "El campo no puede estar vacío";
                  }),
              const SizedBox(height: 10),
              _ComboBox(inputSearch: inputSearch),
              const SizedBox(height: 10),
              Row(
                children: [
                  TextButton(
                      onPressed: () async {
                        // await storage.delete(key: "linea");
                        // await storage.delete(key: "grupo");
                        Navigator.pop(context);
                      },
                      child: const Text("Cancelar")),
                  FutureBuilder(
                    future: authServices.readToken("auth-token"),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      return TextButton(
                          onPressed: () async {
                            final inputSearch =
                                Provider.of<SearchBalanceFormProvider>(context,
                                    listen: false);

                            String query = querySQL(
                                inputSearch.codProducto,
                                inputSearch.producto,
                                inputSearch.bodega,
                                inputSearch.linea,
                                inputSearch.grupo,
                                inputSearch.saldo,
                                0,
                                15);
                            print(query);

                            await balanceServices.getSaldosByFilters(
                                query, "0", "10", snapshot.data!);

                            Navigator.pushNamed(context,
                                CheckBalanceScreenWithGrupos.routerName,
                                arguments: ScreenArgumentsFilter(
                                    inputSearch.bodega,
                                    inputSearch.producto,
                                    inputSearch.codProducto,
                                    inputSearch.grupo,
                                    inputSearch.linea,
                                    inputSearch.saldo));

                            // await storage.delete(key: "linea");
                            // await storage.delete(key: "grupo");
                          },
                          child: const Text("Buscar"));
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _ComboBox extends StatelessWidget {
  const _ComboBox({
    Key? key,
    required this.inputSearch,
  }) : super(key: key);

  final SearchBalanceFormProvider inputSearch;

  @override
  Widget build(BuildContext context) {
    final authServices = Provider.of<AuthServices>(context);
    final auxiliarServices = Provider.of<AuxiliarServices>(context);

    var seen = Set<Grupos>();
    List<Grupos> dataContentGrupos = auxiliarServices.onDisplayGrupo
        .where((grupo) => seen.add(grupo))
        .toList();
    return Column(
      children: [
        DropdownButtonFormField<String>(
          items: auxiliarServices.onDisplayBodegas
              .map(
                (index) => DropdownMenuItem(
                    value: index.desBod,
                    child: Text("${index.codBod}-${index.desBod}")),
              )
              .toList(),
          onChanged: (value) {
            inputSearch.bodega = value ?? "";
          },
          decoration: InputDecorations.authInputDecoration(
              hint: "",
              label: "Bodegas",
              icon: Icons.admin_panel_settings_outlined),
        ),
        const SizedBox(height: 10),
        //TODO: IF
        // if (auxiliarServices.onDisplayLineas.length > 40)
        //   Row(
        //     children: [
        //       Expanded(
        //         child: Text("Linea: ${inputSearch.linea}"),
        //       ),
        //       const SizedBox(width: 20),
        //       const _BotonExaminar(label: '...', endpoint: "linea"),
        //     ],
        //   ),
        // if (auxiliarServices.onDisplayLineas.length <= 40)
        DropdownButtonFormField<String>(
          items: auxiliarServices.onDisplayLineas
              .map(
                (index) => DropdownMenuItem(
                    value: "${index.codLinea}||${index.desLinea}",
                    child: Text("${index.codLinea}-${index.desLinea}")),
              )
              .toList(),
          onChanged: (value) {
            inputSearch.linea = value ?? "";
          },
          decoration: InputDecorations.authInputDecoration(
              hint: "",
              label: "Linea",
              icon: Icons.admin_panel_settings_outlined),
        ),
        const SizedBox(height: 10),
        //TODO: IF
        // if (auxiliarServices.onDisplayGrupo.length > 40)
        //   Row(
        //     children: [
        //       Expanded(
        //         child: Text("Grupo: ${inputSearch.grupo}"),
        //       ),
        //       const SizedBox(width: 20),
        //       const _BotonExaminar(label: '...', endpoint: "grupo"),
        //     ],
        //   ),
        // if (auxiliarServices.onDisplayGrupo.length <= 40)
        DropdownButtonFormField<String>(
          style: const TextStyle(fontSize: 12, color: Colors.black),
          items: dataContentGrupos
              .map(
                (index) => DropdownMenuItem(
                    value:
                        "${index.tipoGru}${index.codigoGru}||${index.descGru}"
                            .trim(),
                    child: Text(
                        "${index.tipoGru}-${index.codigoGru}-${index.descGru}")),
              )
              .toList(),
          onChanged: (value) {
            inputSearch.grupo = value ?? "";
          },
          decoration: InputDecorations.authInputDecoration(
            hint: "",
            label: "Grupo",
            icon: Icons.admin_panel_settings_outlined,
          ),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          items: const [
            DropdownMenuItem(value: "", child: Text("Sin Filtro de Saldo")),
            DropdownMenuItem(
                value: "Saldos Positivos", child: Text("Saldos Positivos")),
            DropdownMenuItem(
                value: "Saldos Iguales a 0", child: Text("Saldos Iguales a 0")),
            DropdownMenuItem(
                value: "Saldos Negativos", child: Text("Saldos Negativos")),
          ],
          onChanged: (value) {
            inputSearch.saldo = value ?? "";
          },
          decoration: InputDecorations.authInputDecoration(
              hint: "",
              label: "Saldos",
              icon: Icons.admin_panel_settings_outlined),
        ),
      ],
    );
  }
}

class _BotonExaminar extends StatelessWidget {
  final String label;
  final String endpoint;
  const _BotonExaminar({
    Key? key,
    required this.label,
    required this.endpoint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      disabledColor: Colors.grey,
      elevation: 0,
      color: AppTheme.primary,
      onPressed: () {
        _modalExaminar(context, label, endpoint);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search, color: Colors.white, size: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _modalExaminar(BuildContext context, String title, String endpoint) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => SearchBalanceFormProvider()),
          ],
          child: _ModalExaminar(title: title, endpoint: endpoint),
        );
      });
}

class _ModalExaminar extends StatelessWidget {
  const _ModalExaminar({Key? key, required this.title, required this.endpoint})
      : super(key: key);

  final String title;

  final String endpoint;

  @override
  Widget build(BuildContext context) {
    final inputSearch = Provider.of<SearchBalanceFormProvider>(context);
    final auxiliarServices = Provider.of<AuxiliarServices>(context);
    const storage = FlutterSecureStorage();

    if (endpoint == "linea") {
      return AlertDialog(
          elevation: 5,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(10)),
          title: Text(title),
          content: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                dataRowColor: MaterialStateColor.resolveWith(
                    (states) => const Color.fromRGBO(255, 255, 255, 0.4)),
                headingRowColor: MaterialStateColor.resolveWith(
                    (states) => const Color.fromRGBO(145, 145, 145, 0.3)),
                columnSpacing: 15,
                columns: const [
                  DataColumn(label: Text("Código de Linea")),
                  DataColumn(label: Text("Descripción")),
                ],
                rows: auxiliarServices.onDisplayLineas
                    .map((index) => DataRow(cells: [
                          DataCell(Center(child: Text(index.codLinea)),
                              onTap: () async {
                            inputSearch.linea = index.desLinea;
                            await storage.write(
                                key: "linea", value: inputSearch.linea);
                            print(inputSearch.linea);
                            Navigator.pop(context);
                          }),
                          DataCell(Center(child: Text(index.desLinea)),
                              onTap: () async {
                            inputSearch.linea = index.desLinea;
                            await storage.write(
                                key: "linea", value: inputSearch.linea);
                            print(inputSearch.linea);
                            Navigator.pop(context);
                            //Todo set State
                          }),
                        ]))
                    .toList(),
              ),
            ),
          ));
    }

    if (endpoint == "grupo") {
      return AlertDialog(
          elevation: 5,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(10)),
          title: Text(title),
          content: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                dataRowColor: MaterialStateColor.resolveWith(
                    (states) => const Color.fromRGBO(255, 255, 255, 0.4)),
                headingRowColor: MaterialStateColor.resolveWith(
                    (states) => const Color.fromRGBO(145, 145, 145, 0.3)),
                columnSpacing: 50,
                columns: const [
                  DataColumn(label: Text("Tipo")),
                  DataColumn(label: Text("Cód")),
                  DataColumn(label: Text("Descrip")),
                ],
                rows: auxiliarServices.onDisplayGrupo
                    .map((index) => DataRow(cells: [
                          DataCell(Center(child: Text(index.tipoGru)),
                              onTap: () {
                            inputSearch.grupo =
                                "${index.tipoGru}${index.codigoGru}-${index.descGru}"
                                    .trim();
                          }),
                          DataCell(
                              Center(child: Text(index.codigoGru.toString())),
                              onTap: () async {
                            inputSearch.grupo =
                                "${index.tipoGru}${index.codigoGru}-${index.descGru}"
                                    .trim();
                            await storage.write(
                                key: "grupo", value: inputSearch.grupo);
                            print(inputSearch.grupo);
                            Navigator.pop(context);
                          }),
                          DataCell(Center(child: Text(index.descGru)),
                              onTap: () async {
                            inputSearch.grupo =
                                "${index.tipoGru}${index.codigoGru}-${index.descGru}"
                                    .trim();
                            await storage.write(
                                key: "grupo", value: inputSearch.grupo);
                            print(inputSearch.grupo);
                            Navigator.pop(context);
                          }),
                        ]))
                    .toList(),
              ),
            ),
          ));
    }
    return Container();
  }
}
