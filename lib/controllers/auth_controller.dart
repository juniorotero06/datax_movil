import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;

class AuthController extends GetxController {
  final String _baseUrl = "10.0.3.2:3001";
  String token = "";
  String validate = "";
  void validateToken() async {
    final url = Uri.http(_baseUrl, "/api/test");
    final resp = await http.get(url, headers: {
      "auth-token": token,
    });
    validate = resp.body;
    print("VALIDATE: $validate");
  }

  @override
  void onInit() {
    super.onInit();
    validateToken();
  }

  // @override
  // void onReady() {
  //   validateToken();
  //   super.onReady();
  // }
}
