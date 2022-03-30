import 'package:datax_movil/widgets/widgets.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const String routerName = "home";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("Home")),
        ),
        drawer: CustomDrawer(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("isDarkMode: "),
            Divider(),
            Text("Genero: "),
            Divider(),
            Text("Nombre de usuario: "),
            Divider(),
          ],
        ));
  }
}
