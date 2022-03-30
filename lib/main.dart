import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:datax_movil/provider/theme_provider.dart';
import 'package:datax_movil/shared_preferences/preferences.dart';
import 'package:datax_movil/screens/screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.init();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
          create: (_) => ThemeProvider(isDarkmode: Preferences.isDarkmode))
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'DataX',
        debugShowCheckedModeBanner: false,
        initialRoute: LoginScreen.rounterName,
        routes: {
          LoginScreen.rounterName: (_) => LoginScreen(),
          HomeScreen.routerName: (_) => const HomeScreen(),
          SettingsScreen.routerName: (_) => const SettingsScreen()
        },
        theme: Provider.of<ThemeProvider>(context).currentTheme);
  }
}
