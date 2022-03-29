import 'package:datax_movil/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:datax_movil/screens/screens.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'DataX',
        debugShowCheckedModeBanner: false,
        initialRoute: 'login',
        routes: {
          'login': (_) => LoginScreen(),
          'home': (_) => const HomeScreen()
        },
        theme: AppTheme.lightTheme);
  }
}
