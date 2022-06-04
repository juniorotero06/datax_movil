import 'package:datax_movil/controllers/controllers.dart';
import 'package:datax_movil/helpers/query_sql.dart';
import 'package:datax_movil/screens/check_cartera_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:provider/provider.dart';

import '../services/services.dart';
import '../themes/app_theme.dart';

void displayModalCartera(BuildContext context, String title, String token) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return _ModalCartera(title: title, token: token);
      });
}

class _ModalCartera extends StatelessWidget {
  final String title;
  final String token;
  const _ModalCartera({
    Key? key,
    required this.title,
    required this.token,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final balanceServices = Provider.of<BalanceServices>(context);
    final authServices = Provider.of<AuthServices>(context);
    return GetBuilder<ModalCarteraController>(
      init: ModalCarteraController(),
      builder: (_) => AlertDialog(
        elevation: 5,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.circular(10)),
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
                activeColor: AppTheme.primary,
                title: const Text("Cuentas por Cobrar"),
                value: _.cXCEnabled,
                onChanged: (value) {
                  //_.cXCEnabled = value ?? false;
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
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    return TextButton(
                        onPressed: () async {
                          _.isCXPCChange();
                          String query = queryCXX_CXP(
                              _.cXCEnabled, _.cxPEnabled, _.isCXPC);
                          print(query);

                          if (query != "") {
                            await balanceServices.getCartera(
                                query, token, _.isCXPC);

                            await Get.to(const CheckCarteraScreen(),
                                arguments: _.isCXPC);
                          }
                        },
                        child: const Text("Buscar"));
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
