import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:datax_movil/main.dart' show ScreenArguments;
import 'package:datax_movil/widgets/widgets.dart';

import '../provider/input_search.dart';
import '../themes/app_theme.dart';
import '../ui/input_decoration.dart';
import '../screens/screens.dart';
import '../services/services.dart';

class FilterBalanceScreen extends StatelessWidget {
  static const String routerName = "filter_balance";
  const FilterBalanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authServices = Provider.of<AuthServices>(context);
    final balanceServices = Provider.of<BalanceServices>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.primary,
          title: const Center(child: Text("Consulte su saldo de inventario")),
        ),
        body: Background(
          child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 10),
              children: [
                const SizedBox(
                  height: 100,
                ),
                MultiProvider(
                  providers: [
                    ChangeNotifierProvider(
                        create: (_) => InputSearchProvider()),
                  ],
                  child: FutureBuilder(
                    future: authServices.readToken("auth-token"),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (!snapshot.hasData) {
                        return const Text("Sin datos...");
                      }
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 50),
                          _ButtonFilterBalance(
                              routerName: routerName,
                              label: "Consultar Saldo por Bodega",
                              onPress: () {
                                _displayModal(
                                    context,
                                    "Consultar Saldo por Bodega",
                                    snapshot.data!,
                                    "bodega");
                              }),
                          const SizedBox(height: 30),
                          _ButtonFilterBalance(
                              routerName: routerName,
                              label: "Consultar Saldo por su Código",
                              onPress: () {
                                _displayModal(
                                    context,
                                    "Consultar Saldo por su Código",
                                    snapshot.data!,
                                    "codsaldo");
                              }),
                          const SizedBox(height: 30),
                          _ButtonFilterBalance(
                              routerName: routerName,
                              label: "Consultar Saldo por Nombre del Producto",
                              onPress: () {
                                _displayModal(
                                    context,
                                    "Consultar Saldo por Nombre del Producto",
                                    snapshot.data!,
                                    "producto");
                              }),
                          const SizedBox(height: 30),
                          _ButtonFilterBalance(
                              routerName: routerName,
                              label: "Consultar Saldo por Linea",
                              onPress: () {
                                _displayModal(
                                    context,
                                    "Consultar Saldo por Línea",
                                    snapshot.data!,
                                    "linea");
                              }),
                          const SizedBox(height: 30),
                          _ButtonFilterBalance(
                              routerName: routerName,
                              label: "Consultar Saldos en 0",
                              onPress: () async {
                                String data = "=", page = "0", size = "10";
                                await balanceServices.getSaldo(
                                    data, page, size, snapshot.data!);

                                Navigator.pushNamed(
                                    context, CheckBalanceScreen.routerName,
                                    arguments: ScreenArguments("saldo", data));
                              }),
                          const SizedBox(height: 30),
                          _ButtonFilterBalance(
                              routerName: routerName,
                              label: "Consultar Saldos Positivos",
                              onPress: () async {
                                String data = ">", page = "0", size = "10";

                                await balanceServices.getSaldo(
                                    data, page, size, snapshot.data!);

                                Navigator.pushNamed(
                                    context, CheckBalanceScreen.routerName,
                                    arguments: ScreenArguments("saldo", data));
                              }),
                          const SizedBox(height: 30),
                          _ButtonFilterBalance(
                              routerName: routerName,
                              label: "Consultar Saldos Negativos",
                              onPress: () async {
                                String data = "<", page = "0", size = "10";

                                await balanceServices.getSaldo(
                                    data, page, size, snapshot.data!);

                                Navigator.pushNamed(
                                    context, CheckBalanceScreen.routerName,
                                    arguments: ScreenArguments("saldo", data));
                              }),
                          const SizedBox(height: 50),
                        ],
                      );
                    },
                  ),
                ),
              ]),
        ));
  }
}

class _ButtonFilterBalance extends StatelessWidget {
  final String label;
  final void Function()? onPress;
  const _ButtonFilterBalance({
    Key? key,
    required this.routerName,
    required this.label,
    this.onPress,
  }) : super(key: key);

  final String routerName;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      disabledColor: Colors.grey,
      elevation: 0,
      color: AppTheme.primary,
      onPressed: onPress,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.attach_money, color: Colors.white, size: 30),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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

void _displayModal(
    BuildContext context, String title, String token, String endpoint) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => InputSearchProvider()),
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
    final inputSearch = Provider.of<InputSearchProvider>(context);
    final balanceServices = Provider.of<BalanceServices>(context);
    //final requestProvider = Provider.of<RequestProvider>(context);
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
                    hint: "Ingrese la busqueda", label: "", icon: Icons.search),
                onChanged: (value) {
                  inputSearch.search = value;
                  setState(() {});
                },
                validator: (value) {
                  return (value != null)
                      ? null
                      : "El campo no puede estar vacío";
                }),
            const SizedBox(height: 10),
            Row(
              children: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancelar")),
                TextButton(
                    onPressed: () async {
                      final inputSearch = Provider.of<InputSearchProvider>(
                          context,
                          listen: false);
                      String data = inputSearch.search, page = "0", size = "10";

                      if (widget.endpoint == "bodega") {
                        await balanceServices.getBodega(
                            data, page, size, widget.token);
                        Navigator.pushNamed(
                            context, CheckBalanceScreen.routerName,
                            arguments: ScreenArguments("bodega", data));
                      }
                      if (widget.endpoint == "codsaldo") {
                        await balanceServices.getCodSaldo(
                            data, page, size, widget.token);
                        Navigator.pushNamed(
                            context, CheckBalanceScreen.routerName,
                            arguments: ScreenArguments("codsaldo", data));
                      }
                      if (widget.endpoint == "linea") {
                        await balanceServices.getLinea(
                            data, page, size, widget.token);
                        Navigator.pushNamed(
                            context, CheckBalanceScreen.routerName,
                            arguments: ScreenArguments("linea", data));
                      }
                      if (widget.endpoint == "producto") {
                        await balanceServices.getProducto(
                            data, page, size, widget.token);
                        Navigator.pushNamed(
                            context, CheckBalanceScreen.routerName,
                            arguments: ScreenArguments("producto", data));
                      }
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
