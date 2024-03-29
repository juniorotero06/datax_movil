import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import 'package:datax_movil/widgets/modal_cartera.dart';
import 'package:datax_movil/screens/screens.dart';
import 'package:datax_movil/services/services.dart';
import 'package:datax_movil/widgets/widgets.dart';

import '../themes/app_theme.dart';
import '../widgets/modal_home.dart';

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
                          return Center(
                            child: Text("Bienvenido ${snapshot.data}",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                )),
                          );
                        }),
                    const SizedBox(height: 20),
                    FutureBuilder(
                        future: authServices.readToken("codLicense"),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          if (!snapshot.hasData) {
                            return const Text("Sin datos...");
                          }
                          return Center(
                            child: FittedBox(
                              child: Text(
                                "Licencia: ${snapshot.data}",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 25,
                                ),
                              ),
                            ),
                          );
                        }),
                    const SizedBox(height: 50),
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
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.factory_outlined,
                                    color: Colors.white, size: 30),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 20),
                                  child: const FittedBox(
                                    child: Text(
                                      "Consultar Inventario",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            onPressed: () async {
                              await auxiliarServices.getBodegas(snapshot.data!);
                              await auxiliarServices.getLineas(snapshot.data!);
                              await auxiliarServices.getGrupos(snapshot.data!);
                              displayModal(context, "Consultar Inventario",
                                  snapshot.data!);
                            });
                      },
                    ),
                    const SizedBox(height: 50),
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
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.attach_money,
                                    color: Colors.white, size: 30),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 20),
                                  child: const FittedBox(
                                    child: Text(
                                      "Consultar Cartera",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            onPressed: () async {
                              await auxiliarServices.getCuentas(snapshot.data!);
                              displayModalCartera(
                                  context, "Consultar Cartera", snapshot.data!);
                            });
                      },
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ]),
        ));
  }
}
