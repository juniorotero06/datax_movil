import 'package:datax_movil/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:datax_movil/screens/screens.dart';

void main() => runApp(const MyApp());

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
        theme: AppTheme.lightTheme);
  }
}
