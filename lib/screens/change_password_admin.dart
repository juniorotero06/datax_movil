import 'dart:io';

import 'package:datax_movil/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:datax_movil/provider/change_password_provider.dart';
import '../services/auth_services.dart';
import '../themes/app_theme.dart';
import '../ui/input_decoration.dart';
import '../widgets/alerts.dart';
import '../widgets/widgets.dart';

class ChangePasswordAdminScreen extends StatelessWidget {
  static const String rounterName = "change_password_admin";
  const ChangePasswordAdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("Cambiar Contraseña")),
        ),
        drawer: CustomDrawer(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50),
              CardContainer(
                  child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Cambiar Contraseña",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  const SizedBox(height: 30),

                  //GESTOR DE ESTADOS PARA UN SOLO PROVIDERL
                  ChangeNotifierProvider(
                    create: (_) => ChangePasswordProvider(),
                    child: _ChangePasswordForm(),
                  )
                ],
              )),
              const SizedBox(height: 50),
            ],
          ),
        ));
  }
}

class _ChangePasswordForm extends StatefulWidget {
  @override
  State<_ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<_ChangePasswordForm> {
  bool _isConfirmUser = false;
  @override
  Widget build(BuildContext context) {
    final changePasswordForm = Provider.of<ChangePasswordProvider>(context);
    final authServices = Provider.of<AuthServices>(context);
    return Container(
      child: Form(
          key: changePasswordForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              if (_isConfirmUser == false)
                FutureBuilder(
                    future: authServices.readToken("email"),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (!snapshot.hasData) {
                        return const Text("Sin datos...");
                      }
                      changePasswordForm.email = snapshot.data!;
                      final controller =
                          TextEditingController(text: snapshot.data);
                      return TextFormField(
                        autocorrect: false,
                        keyboardType: TextInputType.emailAddress,
                        controller: controller,
                        decoration: InputDecorations.authInputDecoration(
                            hint: "example@email.com",
                            label: "Correo Electrónico",
                            icon: Icons.alternate_email_sharp),
                        onChanged: (value) => changePasswordForm.email = value,
                        validator: (value) {
                          String pattern =
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                          RegExp regExp = RegExp(pattern);

                          return regExp.hasMatch(value ?? "")
                              ? null
                              : "El valor ingresado no es un correo";
                        },
                      );
                    }),
              if (_isConfirmUser == true) const SizedBox(height: 30),
              if (_isConfirmUser == true)
                TextFormField(
                    autocorrect: false,
                    obscureText: true,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecorations.authInputDecoration(
                        hint: "*****",
                        label: "Contraseña Actual",
                        icon: Icons.lock_outline),
                    onChanged: (value) => changePasswordForm.password = value,
                    validator: (value) {
                      return (value != null && value.length >= 6)
                          ? null
                          : "La contraseña debe de ser de 6 caracteres";
                    }),
              if (_isConfirmUser == true) const SizedBox(height: 30),
              if (_isConfirmUser == true)
                TextFormField(
                    autocorrect: false,
                    obscureText: true,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecorations.authInputDecoration(
                        hint: "*****",
                        label: "Nueva Contraseña",
                        icon: Icons.lock_outline),
                    onChanged: (value) =>
                        changePasswordForm.newPassword = value,
                    validator: (value) {
                      return (value != null && value.length >= 6)
                          ? null
                          : "La contraseña debe de ser de 6 caracteres";
                    }),
              const SizedBox(height: 50),
              if (_isConfirmUser == false)
                FutureBuilder(
                  future: authServices.readToken("email"),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (!snapshot.hasData) {
                      return const Text("Sin datos...");
                    }
                    return MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        disabledColor: Colors.grey,
                        elevation: 0,
                        color: AppTheme.primary,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 80, vertical: 15),
                          child: Text(
                            changePasswordForm.isLoading
                                ? "Espere..."
                                : "Canfirmar Usuario",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        onPressed: changePasswordForm.isLoading
                            ? null
                            : () async {
                                FocusScope.of(context).unfocus();
                                if (!changePasswordForm.isValidForm()) return;

                                if (snapshot.data == changePasswordForm.email) {
                                  _isConfirmUser = true;
                                  setState(() {});
                                } else {
                                  return Platform.isAndroid
                                      ? displayDialogAndroid(context, "Error",
                                          "El usuario ingresado no es correcto")
                                      : displayDialogIOS(context, "Error",
                                          "El usuario ingresado no es correcto");
                                }
                              });
                  },
                ),
              if (_isConfirmUser == true)
                FutureBuilder(
                  future: authServices.readToken("auth-token"),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (!snapshot.hasData) {
                      return const Text("Sin datos...");
                    }
                    return MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        disabledColor: Colors.grey,
                        elevation: 0,
                        color: AppTheme.primary,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 80, vertical: 15),
                          child: Text(
                            changePasswordForm.isLoading
                                ? "Espere..."
                                : "Cambiar Contraseña",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        onPressed: changePasswordForm.isLoading
                            ? null
                            : () async {
                                FocusScope.of(context).unfocus();
                                final authServices = Provider.of<AuthServices>(
                                    context,
                                    listen: false);

                                if (!changePasswordForm.isValidForm()) return;

                                //addUserForm.isLoading = true;

                                final String? resp =
                                    await authServices.changePasswordAdmin(
                                        changePasswordForm.email,
                                        changePasswordForm.password,
                                        changePasswordForm.newPassword,
                                        snapshot.data!);

                                if (resp == null) {
                                  //addUserForm.isLoading = false;
                                  Navigator.pushReplacementNamed(
                                      context, HomeScreen.routerName);
                                  return Platform.isAndroid
                                      ? displayDialogAndroid(
                                          context,
                                          "¡Success!",
                                          "Se ha cambiado la contraseña satisfactoriamente")
                                      : displayDialogIOS(context, "¡Success",
                                          "Se ha cambiado la contraseña satisfactoriamente");
                                } else {
                                  //addUserForm.isLoading = false;
                                  return Platform.isAndroid
                                      ? displayDialogAndroid(context, "Error",
                                          "Ha ocurrido un error en el envio de la información")
                                      : displayDialogIOS(context, "Error",
                                          "Ha ocurrido un error en el envio de la información");
                                }
                              });
                  },
                ),
              const SizedBox(height: 30),
            ],
          )),
    );
  }
}
