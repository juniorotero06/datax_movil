import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:datax_movil/screens/screens.dart';
import '../services/services.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authServices = Provider.of<AuthServices>(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const _DrawerHeader(),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            onTap: () {
              Navigator.pushReplacementNamed(context, HomeScreen.routerName);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () {
              Navigator.pushReplacementNamed(
                  context, SettingsScreen.routerName);
            },
          ),
          FutureBuilder(
            future: authServices.readToken("rolName"),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.data == "administrative") {
                return ListTile(
                  leading: const Icon(Icons.person_add),
                  title: const Text("Crear Usuario"),
                  onTap: () {
                    Navigator.pushReplacementNamed(
                        context, AddUserScreen.rounterName);
                  },
                );
              }
              return Container();
            },
          )
        ],
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
        child: Container(),
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/menu-img.jpg"), fit: BoxFit.cover),
        ));
  }
}
