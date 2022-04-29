import 'package:flutter/material.dart';

class CheckBalanceScreen extends StatelessWidget {
  static const String routerName = "check_balance";
  const CheckBalanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Consultar Saldo'),
      ),
    );
  }
}
