import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class CheckBalanceScreen extends StatelessWidget {
  final String? apiRoute;
  static const String routerName = "check_balance";
  const CheckBalanceScreen({Key? key, this.apiRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Tabla de Saldos")),
      ),
      body: const Center(
        child: Text('Consultar Saldo'),
      ),
    );
  }
}
