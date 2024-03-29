import 'package:datax_movil/controllers/controllers.dart';
import 'package:datax_movil/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:provider/provider.dart';

import 'package:datax_movil/screens/screens.dart';
import 'package:datax_movil/services/services.dart';

class CheckAuthScreen extends StatelessWidget {
  static const String rounterName = "check_auth";
  const CheckAuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthServices>(context, listen: false);
    return Scaffold(
      body: Center(
        child: FutureBuilder(
            future: authService.readToken("auth-token"),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (!snapshot.hasData) {
                return const Scaffold(
                    body: Background(
                        child: CircularProgressIndicator.adaptive()));
              }

              if (snapshot.data == '') {
                //microtask se ejecuta justo depsues de la contruccion
                Future.microtask(() {
                  Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (_, __, ___) => LoginScreen(),
                          transitionDuration: const Duration(seconds: 0)));
                });
              } else {
                Future.microtask(() {
                  Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (_, __, ___) => const HomeScreen(),
                          transitionDuration: const Duration(seconds: 0)));
                });
              }

              return GetBuilder<AuthController>(
                init: AuthController(),
                builder: (_) {
                  _.token = snapshot.data!;
                  print("TOKEN: ${_.token}");
                  return const Scaffold(
                      body: Background(
                          child: CircularProgressIndicator.adaptive()));
                },
              );
            }),
      ),
    );
  }
}
