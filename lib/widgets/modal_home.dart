import 'package:datax_movil/controllers/controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
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

class _ModalForm extends StatefulWidget {
  const _ModalForm({
    Key? key,
    required this.title,
    required this.token,
  }) : super(key: key);

  final String title;
  final String token;

  @override
  State<_ModalForm> createState() => _ModalFormState();
}

class _ModalFormState extends State<_ModalForm> {
  late FocusNode fucusTextFieldCodProducto;
  late FocusNode fucusTextFieldProducto;

  @override
  void initState() {
    super.initState();
    fucusTextFieldCodProducto = FocusNode();
    fucusTextFieldProducto = FocusNode();
  }

  @override
  void dispose() {
    // Limpia el nodo focus cuando se haga dispose al formulario
    fucusTextFieldCodProducto.dispose();
    fucusTextFieldProducto.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inputSearch = Provider.of<SearchBalanceFormProvider>(context);
    final balanceServices = Provider.of<BalanceServices>(context);
    final authServices = Provider.of<AuthServices>(context);

    return GetBuilder<ModalHomeController>(
        init: ModalHomeController(),
        builder: (_) {
          final controllerCodProducto =
              TextEditingController(text: _.codProducto);
          final controllerProducto = TextEditingController(text: _.producto);

          return AlertDialog(
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(10)),
            title: Text(widget.title),
            content: Form(
              key: _.formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                              autocorrect: false,
                              controller: controllerCodProducto,
                              focusNode: fucusTextFieldCodProducto,
                              autofocus: true,
                              keyboardType: TextInputType.text,
                              decoration: InputDecorations.authInputDecoration(
                                  hint: "",
                                  label: "Codigo del Producto",
                                  icon: Icons.search),
                              onChanged: (value) {
                                _.codProducto = value;
                              },
                              validator: (value) {
                                return (value != null)
                                    ? null
                                    : "El campo no puede estar vacío";
                              }),
                        ),
                        IconButton(
                            onPressed: () {
                              _.borrarCodProducto();
                              FocusScope.of(context)
                                  .requestFocus(fucusTextFieldProducto);
                              controllerCodProducto.clear();
                            },
                            icon: const Icon(
                              Icons.delete_forever,
                              color: AppTheme.primary,
                            ))
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                              autocorrect: false,
                              controller: controllerProducto,
                              focusNode: fucusTextFieldProducto,
                              keyboardType: TextInputType.text,
                              decoration: InputDecorations.authInputDecoration(
                                  hint: "",
                                  label: "Nombre de Producto",
                                  icon: Icons.search),
                              onChanged: (value) {
                                //inputSearch.producto = value;
                                _.producto = value;
                              },
                              validator: (value) {
                                return (value != null)
                                    ? null
                                    : "El campo no puede estar vacío";
                              }),
                        ),
                        IconButton(
                            onPressed: () {
                              _.borrarProducto();
                              FocusScope.of(context)
                                  .requestFocus(fucusTextFieldCodProducto);
                              controllerProducto.clear();
                            },
                            icon: const Icon(
                              Icons.delete_forever,
                              color: AppTheme.primary,
                            ))
                      ],
                    ),
                    const SizedBox(height: 10),
                    //_ComboBox(inputSearch: inputSearch),
                    _ComboBox(inputSearch: inputSearch),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        TextButton(
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancelar")),
                        TextButton(
                            onPressed: () async {
                              _.limpiar();
                              FocusScope.of(context).unfocus();
                            },
                            child: const Text("Limpiar")),
                        FutureBuilder(
                          future: authServices.readToken("auth-token"),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            return TextButton(
                                onPressed: () async {
                                  String query = querySQL(
                                      _.codProducto,
                                      _.producto,
                                      _.bodega,
                                      _.linea,
                                      _.grupo,
                                      _.saldo,
                                      0,
                                      15);
                                  print(query);

                                  await balanceServices.getSaldosByFilters(
                                      query, "0", "10", snapshot.data!);

                                  Navigator.pushNamed(context,
                                      CheckBalanceScreenWithGrupos.routerName,
                                      arguments: ScreenArgumentsFilter(
                                          _.bodega,
                                          _.producto,
                                          _.codProducto,
                                          _.grupo,
                                          _.linea,
                                          _.saldo));
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
        });
  }
}

class _ComboBox extends StatelessWidget {
  const _ComboBox({Key? key, required this.inputSearch}) : super(key: key);

  final SearchBalanceFormProvider inputSearch;

  @override
  Widget build(BuildContext context) {
    final authServices = Provider.of<AuthServices>(context);
    final auxiliarServices = Provider.of<AuxiliarServices>(context);

    var seen = Set<Grupos>();
    List<Grupos> dataContentGrupos = auxiliarServices.onDisplayGrupo
        .where((grupo) => seen.add(grupo))
        .toList();
    return GetBuilder<ModalHomeController>(builder: (_) {
      final controllerBodegas = TextEditingController(text: _.bodega);
      final controllerLinea = TextEditingController(text: _.linea);
      final controllerGrupo = TextEditingController(text: _.grupo);
      return Column(
        children: [
          if (auxiliarServices.onDisplayBodegas.length > 40)
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                      autocorrect: false,
                      readOnly: true,
                      controller: controllerBodegas,
                      keyboardType: TextInputType.text,
                      decoration: InputDecorations.authInputDecoration(
                          hint: "", label: "Bodega", icon: Icons.search),
                      onChanged: (value) {
                        _.bodega = value;
                      },
                      validator: (value) {
                        return (value != null)
                            ? null
                            : "El campo no puede estar vacío";
                      }),
                ),
                const SizedBox(width: 20),
                const _BotonExaminar(label: '...', endpoint: "bodega"),
              ],
            ),
          if (auxiliarServices.onDisplayLineas.length <= 40)
            DropdownButtonFormField<String>(
              style: const TextStyle(fontSize: 12, color: Colors.black),
              items: auxiliarServices.onDisplayBodegas
                  .map(
                    (index) => DropdownMenuItem(
                        value: index.desBod,
                        child: Text("${index.codBod}-${index.desBod}")),
                  )
                  .toList(),
              onChanged: (value) {
                //inputSearch.bodega = value ?? "";
                _.bodega = value ?? "";
              },
              decoration: InputDecorations.authInputDecoration(
                  hint: "",
                  label: "Bodegas",
                  icon: Icons.admin_panel_settings_outlined),
            ),
          const SizedBox(height: 10),
          //TODO: IF
          if (auxiliarServices.onDisplayLineas.length > 40)
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                      autocorrect: false,
                      controller: controllerLinea,
                      readOnly: true,
                      keyboardType: TextInputType.text,
                      decoration: InputDecorations.authInputDecoration(
                          hint: "", label: "Linea", icon: Icons.search),
                      onChanged: (value) {
                        //inputSearch.codProducto = value;
                        _.linea = value;
                      },
                      validator: (value) {
                        return (value != null)
                            ? null
                            : "El campo no puede estar vacío";
                      }),
                ),
                const SizedBox(width: 20),
                const _BotonExaminar(label: '...', endpoint: "linea"),
              ],
            ),
          if (auxiliarServices.onDisplayLineas.length <= 40)
            DropdownButtonFormField<String>(
              items: auxiliarServices.onDisplayLineas
                  .map(
                    (index) => DropdownMenuItem(
                        value: "${index.codLinea}||${index.desLinea}",
                        child: Text("${index.codLinea}-${index.desLinea}")),
                  )
                  .toList(),
              onChanged: (value) {
                //inputSearch.linea = value ?? "";
                _.linea = value ?? "";
              },
              decoration: InputDecorations.authInputDecoration(
                  hint: "",
                  label: "Linea",
                  icon: Icons.admin_panel_settings_outlined),
            ),
          const SizedBox(height: 10),
          //TODO: IF
          if (auxiliarServices.onDisplayGrupo.length > 40)
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                      autocorrect: false,
                      controller: controllerGrupo,
                      readOnly: true,
                      keyboardType: TextInputType.text,
                      decoration: InputDecorations.authInputDecoration(
                          hint: "", label: "Grupo", icon: Icons.search),
                      onChanged: (value) {
                        //inputSearch.codProducto = value;
                        _.grupo = value;
                      },
                      validator: (value) {
                        return (value != null)
                            ? null
                            : "El campo no puede estar vacío";
                      }),
                ),
                const SizedBox(width: 20),
                const _BotonExaminar(label: '...', endpoint: "grupo"),
              ],
            ),
          if (auxiliarServices.onDisplayGrupo.length <= 40)
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
                //inputSearch.grupo = value ?? "";
                _.grupo = value ?? "";
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
                  value: "Saldos Iguales a 0",
                  child: Text("Saldos Iguales a 0")),
              DropdownMenuItem(
                  value: "Saldos Negativos", child: Text("Saldos Negativos")),
            ],
            onChanged: (value) {
              // inputSearch.saldo = value ?? "";
              _.saldo = value ?? "";
            },
            decoration: InputDecorations.authInputDecoration(
                hint: "",
                label: "Saldos",
                icon: Icons.admin_panel_settings_outlined),
          ),
        ],
      );
    });
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
    return GetBuilder<ModalHomeController>(
      builder: (_) => MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        disabledColor: Colors.grey,
        elevation: 0,
        color: AppTheme.primary,
        onPressed: () {
          _.showModalDataBodega(endpoint);
          //_modalExaminar(context, label, endpoint);
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
      ),
    );
  }
}

// void _modalExaminar(BuildContext context, String title, String endpoint) {
//   showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (context) {
//         return MultiProvider(
//           providers: [
//             ChangeNotifierProvider(create: (_) => SearchBalanceFormProvider()),
//           ],
//           child: ModalExaminar(title: title, endpoint: endpoint),
//         );
//       });
// }

