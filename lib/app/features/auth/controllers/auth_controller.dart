import 'package:get/get.dart';
import '../../../services/auth_service.dart';

class AuthController extends GetxController {
  final isLoading = false.obs;

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    final result =
        await AuthService.signInWithEmailAndPassword(email, password);
    isLoading.value = false;

    if (result == null) {
      Get.offAllNamed('/home');
    } else {
      Get.snackbar('Error', result);
    }
  }

  Future<void> signup(String email, String password, String name) async {
    isLoading.value = true;
    final result =
        await AuthService.signUpWithEmailAndPassword(email, password, name);
    isLoading.value = false;

    if (result == null) {
      Get.offAllNamed('/login');
    } else {
      Get.snackbar('Error', result);
    }
  }
}
