import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

import 'package:datax_movil/provider/theme_provider.dart';
import 'package:datax_movil/shared_preferences/preferences.dart';
import 'package:datax_movil/screens/screens.dart';
import 'package:datax_movil/services/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.init();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthServices()),
      ChangeNotifierProvider(create: (_) => BalanceServices()),
      ChangeNotifierProvider(create: (_) => AuxiliarServices()),
      ChangeNotifierProvider(
          create: (_) => ThemeProvider(isDarkmode: Preferences.isDarkmode)),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'DataX',
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: NotificationsService.messengerKey,
        initialRoute: CheckAuthScreen.rounterName,
        onGenerateRoute: _getRoute,
        routes: {
          LoginScreen.rounterName: (_) => LoginScreen(),
          RegisterScreen.rounterName: (_) => RegisterScreen(),
          HomeScreen.routerName: (_) => const HomeScreen(),
          SettingsScreen.routerName: (_) => const SettingsScreen(),
          CheckAuthScreen.rounterName: (_) => const CheckAuthScreen(),
          AddUserScreen.rounterName: (_) => const AddUserScreen(),
          ChangePasswordAdminScreen.rounterName: (_) =>
              const ChangePasswordAdminScreen(),
          ChangeRoleToUserScreen.rounterName: (_) =>
              const ChangeRoleToUserScreen(),
          CheckBalanceScreen.routerName: (_) => const CheckBalanceScreen(),
          CheckBalanceScreenWithGrupos.routerName: (_) =>
              const CheckBalanceScreenWithGrupos(),
          FilterBalanceScreen.routerName: (_) => const FilterBalanceScreen()
        },
        theme: Provider.of<ThemeProvider>(context).currentTheme);
  }

  Route<dynamic>? _getRoute(RouteSettings settings) {
    if (settings.name == CheckBalanceScreen.routerName) {
      final args = settings.arguments as ScreenArguments;
      return _buildRoute(
          settings,
          CheckBalanceScreen(
            body: args.body,
            endpoint: args.endpoint,
          ));
    }

    if (settings.name == CheckBalanceScreenWithGrupos.routerName) {
      final args = settings.arguments as ScreenArgumentsFilter;
      return _buildRoute(
          settings,
          CheckBalanceScreenWithGrupos(
            bodega: args.bodega,
            codProducto: args.codProducto,
            grupo: args.grupo,
            linea: args.linea,
            producto: args.producto,
            saldo: args.saldo,
          ));
    }

    return null;
  }

  MaterialPageRoute _buildRoute(RouteSettings settings, Widget builder) {
    return MaterialPageRoute(
      settings: settings,
      builder: (context) => builder,
    );
  }
}

class ScreenArguments {
  final String endpoint;
  final String body;
  ScreenArguments(this.endpoint, this.body);
}

class ScreenArgumentsFilter {
  String bodega;
  String producto;
  String codProducto;
  String grupo;
  String linea;
  String saldo;
  ScreenArgumentsFilter(this.bodega, this.producto, this.codProducto,
      this.grupo, this.linea, this.saldo);
}
