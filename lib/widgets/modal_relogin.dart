import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:datax_movil/screens/login_screen.dart';
import '../services/services.dart';
import '../themes/app_theme.dart';

void displayModalCartera(BuildContext context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return const _ModalLogin();
      });
}

class _ModalLogin extends StatelessWidget {
  const _ModalLogin({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authServices = Provider.of<AuthServices>(context, listen: false);
    return AlertDialog(
        elevation: 5,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.circular(10)),
        content: Column(
          children: [
            const Text("Inicia sesión para continuar"),
            MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                disabledColor: Colors.grey,
                elevation: 0,
                color: AppTheme.primary,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.login, color: Colors.white, size: 30),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      child: const FittedBox(
                        child: Text(
                          "Iniciar Sesión",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: () async {
                  await authServices.logout();
                  Navigator.pushReplacementNamed(
                      context, LoginScreen.rounterName);
                })
          ],
        ));
  }
}
