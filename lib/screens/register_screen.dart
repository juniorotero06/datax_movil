import 'package:datax_movil/provider/license_form_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:datax_movil/provider/register_form_provider.dart';
import 'package:datax_movil/screens/screens.dart';
import 'package:datax_movil/themes/app_theme.dart';
import 'package:datax_movil/ui/input_decoration.dart';
import 'package:datax_movil/widgets/widgets.dart';

class RegisterScreen extends StatelessWidget {
  static const String rounterName = "register";
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
                "Registro",
                style: Theme.of(context).textTheme.headline4,
              ),
              const SizedBox(height: 30),

              //GESTOR DE ESTADOS PARA UN SOLO PROVIDERL
              ChangeNotifierProvider(
                create: (_) => RegisterFormProvider(),
                child: _RegisterForm(),
              )
            ],
          )),
          const SizedBox(height: 50),
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, LoginScreen.rounterName);
            },
            child: const Text(
              "¿Ya tienes cuenta?",
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

class _RegisterForm extends StatefulWidget {
  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  bool _isRegisterLicense = false;
  @override
  Widget build(BuildContext context) {
    final registerForm = Provider.of<RegisterFormProvider>(context);

    return Container(
      child: Form(
          key: registerForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.name,
                decoration: InputDecorations.authInputDecoration(
                    hint: "", label: "Nombre", icon: Icons.person),
                onChanged: (value) => registerForm.name = value,
                validator: (value) {
                  String pattern =
                      r"^[\w'\-,.][^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$";
                  RegExp regExp = RegExp(pattern);

                  return regExp.hasMatch(value ?? "")
                      ? null
                      : "El valor ingresado no es un correo";
                },
              ),
              const SizedBox(height: 30),
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.name,
                decoration: InputDecorations.authInputDecoration(
                    hint: "", label: "Apellido", icon: Icons.person),
                onChanged: (value) => registerForm.lastname = value,
                validator: (value) {
                  String pattern =
                      r"^[\w'\-,.][^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$";
                  RegExp regExp = RegExp(pattern);

                  return regExp.hasMatch(value ?? "")
                      ? null
                      : "El valor ingresado no es un correo";
                },
              ),
              const SizedBox(height: 30),
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecorations.authInputDecoration(
                    hint: "example@email.com",
                    label: "Correo Electrónico",
                    icon: Icons.alternate_email_sharp),
                onChanged: (value) => registerForm.email = value,
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
                  onChanged: (value) => registerForm.password = value,
                  validator: (value) {
                    return (value != null && value.length >= 6)
                        ? null
                        : "La contraseña debe de ser de 6 caracteres";
                  }),
              const SizedBox(height: 30),
              CheckboxListTile(
                  activeColor: AppTheme.primary,
                  title: const Text("¿No tiene su licensia registrada aun?"),
                  value: _isRegisterLicense,
                  onChanged: (value) {
                    _isRegisterLicense = value ?? true;
                    setState(() {});
                  }),
              if (_isRegisterLicense)
                ChangeNotifierProvider(
                    child: LicenseForm(), create: (_) => LicenseFormProvider()),
              const SizedBox(height: 50),
              if (!_isRegisterLicense)
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
                        registerForm.isLoading ? "Espere..." : "Crear Usuario",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    onPressed: registerForm.isLoading
                        ? null
                        : () async {
                            FocusScope.of(context).unfocus();

                            if (!registerForm.isValidForm()) return;

                            registerForm.isLoading = true;

                            await Future.delayed(const Duration(seconds: 2));

                            registerForm.isLoading =
                                false; //Validadr que el login sea correcto << backend

                            Navigator.pushReplacementNamed(
                                context, LoginScreen.rounterName);
                          }),
              if (!_isRegisterLicense) const SizedBox(height: 30),
            ],
          )),
    );
  }
}
