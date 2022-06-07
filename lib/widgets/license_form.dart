import 'dart:io';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:datax_movil/provider/license_form_provider.dart';
import '../provider/register_form_provider.dart';
import '../services/services.dart';
import '../themes/app_theme.dart';
import '../ui/input_decoration.dart';
import 'alerts.dart';

class LicenseForm extends StatelessWidget {
  final String registerName;
  final String registerLastname;
  final String registerEmail;
  final String registerPassword;
  final String registerPhone;
  final String rol;

  const LicenseForm(
      {Key? key,
      required this.registerName,
      required this.registerLastname,
      required this.registerEmail,
      required this.registerPassword,
      required this.registerPhone,
      required this.rol})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final licenseForm = Provider.of<LicenseFormProvider>(context);
    final registerForm = Provider.of<RegisterFormProvider>(context);
    return Form(
      key: licenseForm.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.name,
            decoration: InputDecorations.authInputDecoration(
                hint: "", label: "Nombre de la Compañía", icon: Icons.factory),
            onChanged: (value) => licenseForm.companyName = value,
            validator: (value) {
              String pattern =
                  r"^[\w'\-,.][^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$";
              RegExp regExp = RegExp(pattern);

              return regExp.hasMatch(value ?? "")
                  ? null
                  : "El valor ingresado no es permitido";
            },
          ),
          const SizedBox(height: 30),
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.number,
            decoration: InputDecorations.authInputDecoration(
                hint: "",
                label: "Código de la licencia",
                icon: Icons.document_scanner_outlined),
            onChanged: (value) => licenseForm.licenseId = value,
            validator: (value) {
              return (value != null && value.length == 10)
                  ? null
                  : "El valor ingresado no es permitido";
            },
          ),
          const SizedBox(height: 30),
          TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecorations.authInputDecoration(
                  hint: "",
                  label: "Dirección",
                  icon: Icons.location_on_outlined),
              onChanged: (value) => licenseForm.address = value,
              validator: (value) {
                return (value != null && value.length >= 3)
                    ? null
                    : "El valor ingresado no es permitido";
              }),
          const SizedBox(height: 30),
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
                hint: "example@email.com",
                label: "Correo Electrónico",
                icon: Icons.alternate_email_sharp),
            onChanged: (value) => licenseForm.email = value,
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
            keyboardType: TextInputType.phone,
            decoration: InputDecorations.authInputDecoration(
                hint: "", label: "Telefóno de la compañía", icon: Icons.phone),
            onChanged: (value) => licenseForm.phone = value,
            validator: (value) {
              return (value != null && value.length >= 3)
                  ? null
                  : "El valor ingresado no es permitido";
            },
          ),
          const SizedBox(height: 30),
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.name,
            decoration: InputDecorations.authInputDecoration(
                hint: "", label: "Host", icon: Icons.computer),
            onChanged: (value) => licenseForm.host = value,
            validator: (value) {
              String pattern =
                  r"^[\w'\-,.][^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$";
              RegExp regExp = RegExp(pattern);

              return regExp.hasMatch(value ?? "")
                  ? null
                  : "El valor ingresado no es permitido";
            },
          ),
          const SizedBox(height: 30),
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.name,
            decoration: InputDecorations.authInputDecoration(
                hint: "",
                label: "Usuario de la Base de Datos",
                icon: Icons.person),
            onChanged: (value) => licenseForm.bdUser = value,
            validator: (value) {
              String pattern =
                  r"^[\w'\-,.][^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$";
              RegExp regExp = RegExp(pattern);

              return regExp.hasMatch(value ?? "")
                  ? null
                  : "El valor ingresado no es permitido";
            },
          ),
          const SizedBox(height: 30),
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.name,
            decoration: InputDecorations.authInputDecoration(
                hint: "",
                label: "Nombre de la Base de Datos",
                icon: Icons.computer),
            onChanged: (value) => licenseForm.bdName = value,
            validator: (value) {
              String pattern =
                  r"^[\w'\-,.][^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$";
              RegExp regExp = RegExp(pattern);

              return regExp.hasMatch(value ?? "")
                  ? null
                  : "El valor ingresado no es permitido";
            },
          ),
          const SizedBox(height: 30),
          TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hint: "*****",
                  label: "Contraseña de la base de datos",
                  icon: Icons.lock_outline),
              onChanged: (value) => licenseForm.bdPass = value,
              validator: (value) {
                return (value != null && value.length >= 6)
                    ? null
                    : "La contraseña debe de ser de minimo 6 caracteres";
              }),
          const SizedBox(height: 50),
          MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: AppTheme.primary,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: FittedBox(
                  child: Text(
                    licenseForm.isLoading ? "Espere..." : "Crear Usuario",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              onPressed: licenseForm.isLoading
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();
                      final authServices =
                          Provider.of<AuthServices>(context, listen: false);

                      if (!registerForm.isValidForm()) {
                        if (!licenseForm.isValidForm()) return;
                      }

                      licenseForm.isLoading = true;

                      final String? resp = await authServices.licenseData(
                          licenseForm.companyName,
                          licenseForm.licenseId,
                          licenseForm.address,
                          licenseForm.email,
                          licenseForm.phone,
                          licenseForm.host,
                          licenseForm.bdUser,
                          licenseForm.bdName,
                          licenseForm.bdPass,
                          registerName,
                          registerLastname,
                          registerPhone,
                          registerEmail,
                          registerPassword,
                          rol);

                      if (resp == null) {
                        licenseForm.isLoading = false;
                        return Platform.isAndroid
                            ? displayDialogAndroid(context, "¡Enviado!",
                                "Se ha enviado la información satisfactoriamente")
                            : displayDialogIOS(context, "¡Enviado!",
                                "Se ha enviado la información satisfactoriamente");
                      } else {
                        licenseForm.isLoading = false;
                        return Platform.isAndroid
                            ? displayDialogAndroid(context, "Error",
                                "Ha ocurrido un error en el envio de la información")
                            : displayDialogIOS(context, "Error",
                                "Ha ocurrido un error en el envio de la información");
                      }
                    }),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
