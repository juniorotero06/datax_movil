import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:datax_movil/screens/screens.dart';
import 'package:datax_movil/services/services.dart';
import 'package:datax_movil/shared_preferences/preferences.dart';
import 'package:datax_movil/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  static const String routerName = "home";

  const HomeScreen({Key? key}) : super(key: key);

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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("isDarkMode: ${Preferences.isDarkmode} "),
            const Divider(),
            Text("Genero: ${Preferences.gender}"),
            const Divider(),
            Text("Nombre de usuario: ${Preferences.name}"),
            const Divider(),
          ],
        ));
  }
}
