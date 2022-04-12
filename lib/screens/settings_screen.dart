import 'package:datax_movil/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import 'package:datax_movil/provider/theme_provider.dart';
import 'package:datax_movil/shared_preferences/preferences.dart';
import 'package:datax_movil/widgets/widgets.dart';

class SettingsScreen extends StatefulWidget {
  static const String routerName = "settings";
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // bool isDarkMode = false;
  // int gender = 1;
  // String name = "Edgar";

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authServices = Provider.of<AuthServices>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Settings")),
      ),
      drawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Ajustes",
              style: TextStyle(fontSize: 45, fontWeight: FontWeight.w300),
            ),
            const Divider(),
            SwitchListTile.adaptive(
                value: Preferences.isDarkmode,
                title: const Text("Darkmode"),
                onChanged: (value) {
                  Preferences.isDarkmode = value;

                  value
                      ? themeProvider.setDarkMode
                      : themeProvider.setLightMode;

                  setState(() {});
                }),
            const Divider(),
            RadioListTile<int>(
                value: 1,
                title: const Text("Masculino"),
                groupValue: Preferences.gender,
                onChanged: (value) {
                  Preferences.gender = value ?? 1;
                  setState(() {});
                }),
            const Divider(),
            RadioListTile<int>(
                value: 2,
                title: const Text("Femenino"),
                groupValue: Preferences.gender,
                onChanged: (value) {
                  Preferences.gender = value ?? 2;
                  setState(() {});
                }),
            const Divider(),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: FutureBuilder(
                    future: authServices.readToken("fullName"),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (!snapshot.hasData) {
                        return const Text("Sin datos...");
                      }
                      return Text("Nombre del usuario: " + snapshot.data!);
                    })),
            const Divider(),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: FutureBuilder(
                    future: authServices.readToken("rolName"),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (!snapshot.hasData) {
                        return const Text("Sin datos...");
                      }
                      return Text("rol: " + snapshot.data!);
                    })),
            const Divider(),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: FutureBuilder(
                    future: authServices.readToken("rolId"),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (!snapshot.hasData) {
                        return const Text("Sin datos...");
                      }
                      return Text("id del rol: " + snapshot.data!);
                    })),
          ],
        )),
      ),
    );
  }
}
