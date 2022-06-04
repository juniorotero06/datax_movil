import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';

class ModalExaminarController extends GetxController {
  String _inputBodega = "";
  String _inputLinea = "";
  String _inputGrupo = "";

  String _endpoint = "";
  String get endpoint => _endpoint;
  // String get inputBodega => _inputBodega;
  // String get inputLinea => _inputLinea;
  // String get inputGrupo => _inputGrupo;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _endpoint = Get.arguments;
  }

  void onInputChangedTextBodega(String text) {
    _inputBodega = text;
    Get.back(result: _inputBodega);
  }

  void onInputChangedTextLinea(String text) {
    _inputLinea = text;
    Get.back(result: _inputLinea);
  }

  void onInputChangedTextGrupo(String text) {
    _inputGrupo = text;
    Get.back(result: _inputGrupo);
  }
}
