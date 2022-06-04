import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';

class CheckCarteraController extends GetxController {
  late bool isCXPC;
  @override
  void onInit() {
    super.onInit();
    isCXPC = Get.arguments;
  }
}
