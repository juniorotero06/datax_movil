import 'package:datax_movil/controllers/controllers.dart';
import 'package:datax_movil/helpers/query_sql.dart';
import 'package:datax_movil/screens/check_cartera_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:provider/provider.dart';

import '../services/services.dart';
import '../themes/app_theme.dart';
import '../ui/input_decoration.dart';

void displayModalCartera(BuildContext context, String title, String token) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return _ModalCartera(title: title, token: token);
      });
}

class _ModalCartera extends StatefulWidget {
  final String title;
  final String token;
  const _ModalCartera({
    Key? key,
    required this.title,
    required this.token,
  }) : super(key: key);

  @override
  State<_ModalCartera> createState() => _ModalCarteraState();
}

class _ModalCarteraState extends State<_ModalCartera> {
  late FocusNode fucusTextFieldCodTercero;
  late FocusNode fucusTextFieldNomTercero;

  @override
  void initState() {
    super.initState();
    fucusTextFieldCodTercero = FocusNode();
    fucusTextFieldNomTercero = FocusNode();
  }

  @override
  void dispose() {
    // Limpia el nodo focus cuando se haga dispose al formulario
    fucusTextFieldCodTercero.dispose();
    fucusTextFieldNomTercero.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final balanceServices = Provider.of<BalanceServices>(context);
    final authServices = Provider.of<AuthServices>(context);
    final auxiliarServices = Provider.of<AuxiliarServices>(context);
    return GetBuilder<ModalCarteraController>(
      init: ModalCarteraController(),
      builder: (_) {
        final controllerCodTercero = TextEditingController(text: _.codTercero);
        final controllerNomTercero = TextEditingController(text: _.nomTercero);
        return AlertDialog(
          elevation: 5,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(10)),
          title: Text(widget.title),
          content: Form(
            key: _.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CheckboxListTile(
                      activeColor: AppTheme.primary,
                      title: const Text("Cuentas por Cobrar"),
                      value: _.cXCEnabled,
                      onChanged: (value) {
                        _.pressCheckCXC(value ?? false);
                        print("CXC: ${_.cXCEnabled}");
                      }),
                  const SizedBox(height: 10),
                  CheckboxListTile(
                      activeColor: AppTheme.primary,
                      title: const Text("Cuentas por Pagar"),
                      value: _.cxPEnabled,
                      onChanged: (value) {
                        //_.cxPEnabled = value ?? false;
                        _.pressCheckCXP(value ?? false);
                        print("CXP: ${_.cxPEnabled}");
                      }),
                  const SizedBox(height: 10),
                  if (_.cXCEnabled && !_.cxPEnabled && !_.isCXPC)
                    DropdownButtonFormField<String>(
                      items: auxiliarServices.onDisplayCuentasxCobrar.cxc
                          .map(
                            (index) => DropdownMenuItem(
                                value: "${index.cuenta}||${index.cuentaNom}",
                                child: Text(
                                    "${index.cuenta}-${auxiliarServices.onDisplayCuentasxCobrar.clase}-${index.cuentaNom}")),
                          )
                          .toList(),
                      onChanged: (value) {
                        _.cuenta = value ?? "";
                      },
                      decoration: InputDecorations.authInputDecoration(
                          hint: "",
                          label: "Cuentas Por Cobrar",
                          icon: Icons.admin_panel_settings_outlined),
                    ),
                  if (_.cxPEnabled && !_.cXCEnabled && !_.isCXPC)
                    DropdownButtonFormField<String>(
                      items: auxiliarServices.onDisplayCuentasxPagar.cxp
                          .map(
                            (index) => DropdownMenuItem(
                                value: "${index.cuenta}||${index.cuentaNom}",
                                child: Text(
                                    "${index.cuenta}-${auxiliarServices.onDisplayCuentasxPagar.clase}-${index.cuentaNom}")),
                          )
                          .toList(),
                      onChanged: (value) {
                        _.cuenta = value ?? "";
                      },
                      decoration: InputDecorations.authInputDecoration(
                          hint: "",
                          label: "Cuentas Por Pagar",
                          icon: Icons.admin_panel_settings_outlined),
                    ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                            autocorrect: false,
                            controller: controllerCodTercero,
                            focusNode: fucusTextFieldCodTercero,
                            autofocus: true,
                            keyboardType: TextInputType.text,
                            decoration: InputDecorations.authInputDecoration(
                                hint: "",
                                label: "Codigo de Tercero",
                                icon: Icons.password_outlined),
                            onChanged: (value) {
                              _.codTercero = value;
                            },
                            validator: (value) {
                              return (value != null)
                                  ? null
                                  : "El campo no puede estar vacío";
                            }),
                      ),
                      IconButton(
                          onPressed: () {
                            _.borrarCodTercero();
                            FocusScope.of(context)
                                .requestFocus(fucusTextFieldNomTercero);
                            controllerCodTercero.clear();
                          },
                          icon: const Icon(
                            Icons.delete_forever,
                            color: AppTheme.primary,
                          ))
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                            autocorrect: false,
                            controller: controllerNomTercero,
                            focusNode: fucusTextFieldNomTercero,
                            keyboardType: TextInputType.text,
                            decoration: InputDecorations.authInputDecoration(
                                hint: "",
                                label: "Nombre de Tercero",
                                icon: Icons.password_outlined),
                            onChanged: (value) {
                              _.nomTercero = value;
                            },
                            validator: (value) {
                              return (value != null)
                                  ? null
                                  : "El campo no puede estar vacío";
                            }),
                      ),
                      IconButton(
                          onPressed: () {
                            _.borrarNomTercero();
                            FocusScope.of(context)
                                .requestFocus(fucusTextFieldCodTercero);
                            controllerNomTercero.clear();
                          },
                          icon: const Icon(
                            Icons.delete_forever,
                            color: AppTheme.primary,
                          ))
                    ],
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancelar")),
                          TextButton(
                              onPressed: () {
                                _.limpiar();
                              },
                              child: const Text("Limpiar")),
                          FutureBuilder(
                            future: authServices.readToken("auth-token"),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              return TextButton(
                                  onPressed: () async {
                                    _.isCXPCChange();
                                    String query = queryCXX_CXP(
                                        _.cXCEnabled,
                                        _.cxPEnabled,
                                        _.isCXPC,
                                        _.cuenta,
                                        _.codTercero,
                                        _.nomTercero);
                                    print(query);

                                    if (query != "") {
                                      await balanceServices.getCartera(
                                          query, widget.token, _.isCXPC);

                                      await Get.to(
                                          () => const CheckCarteraScreen(),
                                          arguments: _.isCXPC);
                                    }
                                  },
                                  child: const Text("Buscar"));
                            },
                          )
                        ],
                      ),
                      TextButton(
                          onPressed: () {
                            _.selectAllOptions();
                          },
                          child: const Text("Seleccionar Todas")),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
