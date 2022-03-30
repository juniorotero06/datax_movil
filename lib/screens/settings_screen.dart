import 'package:flutter/material.dart';

import 'package:datax_movil/widgets/widgets.dart';

class SettingsScreen extends StatefulWidget {
  static const String routerName = "settings";
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;
  int gender = 1;
  String name = "Edgar";

  @override
  Widget build(BuildContext context) {
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
                value: isDarkMode,
                title: const Text("DarkMode"),
                onChanged: (value) {
                  isDarkMode = value;
                  setState(() {});
                }),
            const Divider(),
            RadioListTile<int>(
                value: 1,
                title: const Text("Masculino"),
                groupValue: gender,
                onChanged: (value) {
                  gender = value ?? 1;
                  setState(() {});
                }),
            const Divider(),
            RadioListTile<int>(
                value: 2,
                title: const Text("Femenino"),
                groupValue: gender,
                onChanged: (value) {
                  gender = value ?? 2;
                  setState(() {});
                }),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                initialValue: "Junior",
                decoration:
                    const InputDecoration(labelText: "Nombre del usuario"),
                onChanged: (value) {
                  name = value;
                  setState(() {});
                },
              ),
            )
          ],
        )),
      ),
    );
  }
}
