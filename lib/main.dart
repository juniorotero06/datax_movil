import 'package:flutter/material.dart';
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
    return MaterialApp(
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
          FilterBalanceScreen.routerName: (_) => const FilterBalanceScreen()
        },
        theme: Provider.of<ThemeProvider>(context).currentTheme);
  }

  Route<dynamic>? _getRoute(RouteSettings settings) {
    if (settings.name == CheckBalanceScreen.routerName) {
      // FooRoute constructor expects SomeObject
      final args = settings.arguments as ScreenArguments;
      return _buildRoute(
          settings,
          CheckBalanceScreen(
            body: args.body,
            endpoint: args.endpoint,
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
