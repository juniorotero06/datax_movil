import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:datax_movil/services/services.dart';
import 'package:datax_movil/provider/login_form_provider.dart';
import 'package:datax_movil/screens/screens.dart';
import 'package:datax_movil/themes/app_theme.dart';
import 'package:datax_movil/ui/input_decoration.dart';
import 'package:datax_movil/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  static const String rounterName = "login";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AuthBackground(
            child: SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 250),
          CardContainer(
              child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                "Login",
                style: Theme.of(context).textTheme.headline4,
              ),
              const SizedBox(height: 30),

              //GESTOR DE ESTADOS PARA UN SOLO PROVIDERL
              ChangeNotifierProvider(
                create: (_) => LoginFormProvider(),
                child: _LoginForm(),
              )
            ],
          )),
          const SizedBox(height: 50),
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(
                  context, RegisterScreen.rounterName);
            },
            child: const Text(
              "Crear una nueva cuenta",
              style: TextStyle(fontSize: 20, color: Colors.black87),
            ),
            style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(
                    AppTheme.primary.withOpacity(0.1)),
                shape: MaterialStateProperty.all(const StadiumBorder())),
          ),
          const SizedBox(height: 50),
        ],
      ),
    )));
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Container(
      child: Form(
          key: loginForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecorations.authInputDecoration(
                    hint: "example@email.com",
                    label: "Correo Electrónico",
                    icon: Icons.alternate_email_sharp),
                onChanged: (value) => loginForm.email = value,
                validator: (value) {
                  String pattern =
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regExp = RegExp(pattern);

                  return regExp.hasMatch(value ?? "")
                      ? null
                      : "El valor ingresado no es un correo";
                },
              ),
              const SizedBox(height: 30),
              TextFormField(
                  autocorrect: false,
                  obscureText: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecorations.authInputDecoration(
                      hint: "*****",
                      label: "Contraseña",
                      icon: Icons.lock_outline),
                  onChanged: (value) => loginForm.password = value,
                  validator: (value) {
                    return (value != null && value.length >= 6)
                        ? null
                        : "La contraseña debe de ser de 6 caracteres";
                  }),
              const SizedBox(height: 30),
              MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  disabledColor: Colors.grey,
                  elevation: 0,
                  color: AppTheme.primary,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 15),
                    child: Text(
                      loginForm.isLoading ? "Espere..." : "Ingresar",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  onPressed: loginForm.isLoading
                      ? null
                      : () async {
                          FocusScope.of(context).unfocus();
                          final authServices =
                              Provider.of<AuthServices>(context, listen: false);

                          if (!loginForm.isValidForm()) return;

                          loginForm.isLoading = true;

                          //await Future.delayed(const Duration(seconds: 2));
                          final String? resp = await authServices.loginUser(
                              loginForm.email, loginForm.password);

                          if (resp == null) {
                            Navigator.pushReplacementNamed(
                                context, HomeScreen.routerName);
                          } else {
                            NotificationsService.showSnackBar(resp);
                            loginForm.isLoading =
                                false; //Validadr que el login sea correcto << backend

                          }
                        })
            ],
          )),
    );
  }
}
