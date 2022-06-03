import 'package:get/state_manager.dart';

class ModalCarteraController extends GetxController {
  bool cXCEnabled = false;
  bool cxPEnabled = false;
  String tipo = "";
  String clase = "";

  void pressCheckCXC(bool value) {
    cXCEnabled = value;
    update();
  }

  void pressCheckCXP(bool value) {
    cxPEnabled = value;
    update();
  }

  void limpiar() {
    cXCEnabled = false;
    cxPEnabled = false;
    update();
  }
}
