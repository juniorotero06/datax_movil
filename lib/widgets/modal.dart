import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/input_search.dart';
import '../ui/input_decoration.dart';

void displayModal(
    BuildContext context, String title, void Function()? onPress) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return ChangeNotifierProvider(
          create: (_) => InputSearchProvider(),
          child: _ModalForm(
            title: title,
            onPress: onPress,
          ),
        );
      });
}

class _ModalForm extends StatefulWidget {
  const _ModalForm({Key? key, required this.title, required this.onPress})
      : super(key: key);

  final String title;
  final void Function()? onPress;

  @override
  State<_ModalForm> createState() => _ModalFormState();
}

class _ModalFormState extends State<_ModalForm> {
  @override
  Widget build(BuildContext context) {
    final inputSearch = Provider.of<InputSearchProvider>(context);
    return AlertDialog(
      elevation: 5,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.circular(10)),
      title: Text(widget.title),
      content: Form(
        key: inputSearch.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecorations.authInputDecoration(
                    hint: "Ingrese la busqueda", label: "", icon: Icons.search),
                onChanged: (value) {
                  inputSearch.search = value;
                  setState(() {});
                },
                validator: (value) {
                  return (value != null)
                      ? null
                      : "El campo no puede estar vacío";
                }),
            const SizedBox(height: 10),
            Row(
              children: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancelar")),
                TextButton(
                    onPressed: widget.onPress, child: const Text("Buscar"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
