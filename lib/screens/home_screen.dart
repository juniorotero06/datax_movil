import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import 'package:datax_movil/screens/screens.dart';
import 'package:datax_movil/services/services.dart';
import 'package:datax_movil/widgets/widgets.dart';

import '../provider/search_balance_form_provider.dart';
import '../themes/app_theme.dart';
import '../ui/input_decoration.dart';

class HomeScreen extends StatelessWidget {
  static const String routerName = "home";

  const HomeScreen({Key? key}) : super(key: key);

  final storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    final authServices = Provider.of<AuthServices>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("Home")),
          backgroundColor: AppTheme.primary,
          actions: [
            IconButton(
                onPressed: () async {
                  await authServices.logout();
                  Navigator.pushReplacementNamed(
                      context, LoginScreen.rounterName);
                },
                icon: const Icon(Icons.logout_outlined))
          ],
        ),
        drawer: CustomDrawer(),
        body: Background(
          child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 10),
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 120),
                    FutureBuilder(
                        future: authServices.readToken("fullName"),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          if (!snapshot.hasData) {
                            return const Text("Sin datos...");
                          }
                          return Text("Bienvenido ${snapshot.data}",
                              style: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold));
                        }),
                    const SizedBox(height: 20),
                    FutureBuilder(
                        future: authServices.readToken("codLicense"),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          if (!snapshot.hasData) {
                            return const Text("Sin datos...");
                          }
                          return Text(
                            "Licencia: ${snapshot.data}",
                            style: const TextStyle(
                              fontSize: 25,
                            ),
                          );
                        }),
                    const SizedBox(height: 50),
                    MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        disabledColor: Colors.grey,
                        elevation: 0,
                        color: AppTheme.primary,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.attach_money,
                                color: Colors.white, size: 30),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              child: const Text(
                                "Consultar Saldo",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          Navigator.pushNamed(
                              context, FilterBalanceScreen.routerName);
                        }),
                    const SizedBox(
                      height: 50,
                    ),
                    FutureBuilder(
                      future: authServices.readToken("auth-token"),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        final auxiliarServices =
                            Provider.of<AuxiliarServices>(context);

                        return MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            disabledColor: Colors.grey,
                            elevation: 0,
                            color: AppTheme.primary,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.attach_money,
                                    color: Colors.white, size: 30),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 20),
                                  child: const Text(
                                    "Consultar Saldo Modal",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                            onPressed: () async {
                              await auxiliarServices.getBodegas(snapshot.data!);
                              await auxiliarServices.getLineas(snapshot.data!);
                              await auxiliarServices.getGrupos(snapshot.data!);
                              _displayModal(context, "Consultar Saldo",
                                  snapshot.data!, "linea");
                            });
                      },
                    ),
                    const Divider(),
                  ],
                ),
              ]),
        ));
  }
}

void _displayModal(
    BuildContext context, String title, String token, String endpoint) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => SearchBalanceFormProvider()),
          ],
          child: _ModalForm(title: title, token: token, endpoint: endpoint),
        );
      });
}

class _ModalForm extends StatefulWidget {
  const _ModalForm(
      {Key? key,
      required this.title,
      required this.token,
      required this.endpoint})
      : super(key: key);

  final String title;
  final String token;
  final String endpoint;
  @override
  State<_ModalForm> createState() => _ModalFormState();
}

class _ModalFormState extends State<_ModalForm> {
  @override
  Widget build(BuildContext context) {
    final inputSearch = Provider.of<SearchBalanceFormProvider>(context);
    final balanceServices = Provider.of<BalanceServices>(context);

    return AlertDialog(
      elevation: 5,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.circular(10)),
      title: Text(widget.title),
      content: Form(
        key: inputSearch.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecorations.authInputDecoration(
                    hint: "Codigo del Prodcuto", label: "", icon: Icons.search),
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
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecorations.authInputDecoration(
                    hint: "Nombre de Prodcuto", label: "", icon: Icons.search),
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
            Row(
              children: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancelar")),
                TextButton(
                    onPressed: () async {
                      // final inputSearch =
                      //     Provider.of<SearchBalanceFormProvider>(context,
                      //         listen: false);
                      // String data = inputSearch.search, page = "0", size = "10";

                      // if (widget.endpoint == "bodega") {
                      //   await balanceServices.getBodega(
                      //       data, page, size, widget.token);
                      //   Navigator.pushNamed(
                      //       context, CheckBalanceScreen.routerName,
                      //       arguments: ScreenArguments("bodega", data));
                      // }
                      // if (widget.endpoint == "codsaldo") {
                      //   await balanceServices.getCodSaldo(
                      //       data, page, size, widget.token);
                      //   Navigator.pushNamed(
                      //       context, CheckBalanceScreen.routerName,
                      //       arguments: ScreenArguments("codsaldo", data));
                      // }
                      // if (widget.endpoint == "linea") {
                      //   await balanceServices.getLinea(
                      //       data, page, size, widget.token);
                      //   Navigator.pushNamed(
                      //       context, CheckBalanceScreen.routerName,
                      //       arguments: ScreenArguments("linea", data));
                      // }
                      // if (widget.endpoint == "producto") {
                      //   await balanceServices.getProducto(
                      //       data, page, size, widget.token);
                      //   Navigator.pushNamed(
                      //       context, CheckBalanceScreen.routerName,
                      //       arguments: ScreenArguments("producto", data));
                      // }
                    },
                    child: const Text("Buscar"))
              ],
            )
          ],
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
    final auxiliarServices = Provider.of<AuxiliarServices>(context);

    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: "",
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
        const SizedBox(height: 20),
        DropdownButtonFormField<String>(
          value: "",
          items: auxiliarServices.onDisplayLineas
              .map(
                (index) => DropdownMenuItem(
                    value: index.desLinea,
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
        const SizedBox(height: 20),
        DropdownButtonFormField<String>(
          value: "",
          items: auxiliarServices.onDisplayGrupo
              .map(
                (index) => DropdownMenuItem(
                    value: index.descGru,
                    child: Text("${index.codigoGru}-${index.descGru}")),
              )
              .toList(),
          onChanged: (value) {
            inputSearch.grupo = value ?? "";
          },
          decoration: InputDecorations.authInputDecoration(
              hint: "",
              label: "Grupo",
              icon: Icons.admin_panel_settings_outlined),
        ),
      ],
    );
  }
}
