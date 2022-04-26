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
        routes: {
          LoginScreen.rounterName: (_) => LoginScreen(),
          RegisterScreen.rounterName: (_) => RegisterScreen(),
          HomeScreen.routerName: (_) => const HomeScreen(),
          SettingsScreen.routerName: (_) => const SettingsScreen(),
          CheckAuthScreen.rounterName: (_) => const CheckAuthScreen(),
          AddUserScreen.rounterName: (_) => AddUserScreen(),
          ChangePasswordAdminScreen.rounterName: (_) =>
              const ChangePasswordAdminScreen(),
          ChangeRoleToUserScreen.rounterName: (_) =>
              const ChangeRoleToUserScreen()
        },
        theme: Provider.of<ThemeProvider>(context).currentTheme);
  }
}
