import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:datax_movil/services/services.dart';
import 'package:datax_movil/provider/add_user_form_provider.dart';
import 'package:datax_movil/themes/app_theme.dart';
import 'package:datax_movil/ui/input_decoration.dart';
import 'package:datax_movil/widgets/widgets.dart';
import '../widgets/alerts.dart';

class AddUserScreen extends StatelessWidget {
  static const String rounterName = "add_user";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("Crear Usuario")),
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
                    "Crear Usuario",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  const SizedBox(height: 30),

                  //GESTOR DE ESTADOS PARA UN SOLO PROVIDERL
                  ChangeNotifierProvider(
                    create: (_) => AddUserFormProvider(),
                    child: _AddUserForm(),
                  )
                ],
              )),
              const SizedBox(height: 50),
            ],
          ),
        ));
  }
}

class _AddUserForm extends StatefulWidget {
  @override
  State<_AddUserForm> createState() => _AddUserFormState();
}

class _AddUserFormState extends State<_AddUserForm> {
  @override
  Widget build(BuildContext context) {
    final addUserForm = Provider.of<AddUserFormProvider>(context);
    final authServices = Provider.of<AuthServices>(context);
    return Container(
      child: Form(
          key: addUserForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.name,
                decoration: InputDecorations.authInputDecoration(
                    hint: "", label: "Nombre", icon: Icons.person),
                onChanged: (value) => addUserForm.name = value,
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
                onChanged: (value) => addUserForm.lastname = value,
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
                keyboardType: TextInputType.phone,
                decoration: InputDecorations.authInputDecoration(
                    hint: "", label: "Telefóno", icon: Icons.phone),
                onChanged: (value) => addUserForm.phone = value,
                validator: (value) {
                  return (value != null && value.length == 10)
                      ? null
                      : "El valor ingresado no es permitido";
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
                onChanged: (value) => addUserForm.email = value,
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
                  onChanged: (value) => addUserForm.password = value,
                  validator: (value) {
                    return (value != null && value.length >= 6)
                        ? null
                        : "La contraseña debe de ser de 6 caracteres";
                  }),
              const SizedBox(height: 30),
              FutureBuilder(
                  future: authServices.readToken("codLicense"),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (!snapshot.hasData) {
                      return const Text("Sin datos...");
                    }
                    addUserForm.licenseId = snapshot.data!;
                    final controller =
                        TextEditingController(text: snapshot.data);
                    return TextFormField(
                      controller: controller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecorations.authInputDecoration(
                          hint: "",
                          label: "Código de la licencia",
                          icon: Icons.document_scanner_outlined),
                      onChanged: (value) {
                        //value = controller.text;
                        addUserForm.licenseId = value;
                      },
                      validator: (value) {
                        return (value != null && value.length == 10)
                            ? null
                            : "El valor ingresado no es permitido";
                      },
                    );
                  }),
              const SizedBox(height: 30),
              DropdownButtonFormField<String>(
                value: "User",
                items: const [
                  DropdownMenuItem(value: "User", child: Text("Usuario")),
                  DropdownMenuItem(
                      value: "Accountant", child: Text("Contador")),
                ],
                onChanged: (value) {
                  addUserForm.rol = value ?? "Usuario";
                },
                decoration: InputDecorations.authInputDecoration(
                    hint: "",
                    label: "Rol",
                    icon: Icons.admin_panel_settings_outlined),
              ),
              const SizedBox(height: 50),
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
                          addUserForm.isLoading ? "Espere..." : "Crear Usuario",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      onPressed: addUserForm.isLoading
                          ? null
                          : () async {
                              FocusScope.of(context).unfocus();
                              final authServices = Provider.of<AuthServices>(
                                  context,
                                  listen: false);

                              if (!addUserForm.isValidForm()) return;

                              //addUserForm.isLoading = true;

                              final String? resp =
                                  await authServices.adminRegisterToUser(
                                      addUserForm.name,
                                      addUserForm.lastname,
                                      addUserForm.phone,
                                      addUserForm.email,
                                      addUserForm.password,
                                      addUserForm.licenseId,
                                      addUserForm.rol,
                                      snapshot.data!);

                              if (resp == null) {
                                //addUserForm.isLoading = false;
                                return Platform.isAndroid
                                    ? displayDialogAndroid(context, "¡Enviado!",
                                        "Se ha enviado la información satisfactoriamente")
                                    : displayDialogIOS(context, "¡Enviado!",
                                        "Se ha enviado la información satisfactoriamente");
                              } else {
                                //addUserForm.isLoading = false;
                                return Platform.isAndroid
                                    ? displayDialogAndroid(context, "Error",
                                        "Ha ocurrido un error en el envio de la información, $resp")
                                    : displayDialogIOS(context, "Error",
                                        "Ha ocurrido un error en el envio de la información, $resp");
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
