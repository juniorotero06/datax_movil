import 'package:datax_movil/themes/app_theme.dart';
import 'package:datax_movil/ui/input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:datax_movil/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
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
              _LoginForm()
            ],
          )),
          const SizedBox(height: 50),
          const Text(
            "Crear una nueva cuenta",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
    return Container(
      child: Form(
          child: Column(
        children: [
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
                hint: "example@email.com",
                label: "Correo Electrónico",
                icon: Icons.alternate_email_sharp),
          ),
          const SizedBox(height: 30),
          TextFormField(
            autocorrect: false,
            obscureText: true,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
                hint: "*****", label: "Contraseña", icon: Icons.lock_outline),
          ),
          const SizedBox(height: 30),
          MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: AppTheme.primary,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: const Text(
                  "Ingresar",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onPressed: () {})
        ],
      )),
    );
  }
}
