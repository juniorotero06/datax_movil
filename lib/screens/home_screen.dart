import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import 'package:datax_movil/screens/screens.dart';
import 'package:datax_movil/services/services.dart';
import 'package:datax_movil/shared_preferences/preferences.dart';
import 'package:datax_movil/widgets/widgets.dart';

import '../themes/app_theme.dart';

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
        body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 10),
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                            context, FilterBalanceScreen.routerName);
                      }),
                  const Divider(),
                ],
              ),
            ]));
  }
}
