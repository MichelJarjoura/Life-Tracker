import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../controllers/auth_controller.dart';
import '../routes/app_routes.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final authController = Get.find<AuthController>();
  final _supabase = Supabase.instance.client;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;

  Future<void> submitLogin() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      try {
        final response = await _supabase.auth.signInWithPassword(
          email: emailController.text.trim(),
          password: passwordController.text,
        );

        await authController.saveSession({
          'id': response.user!.id,
          'email': response.user!.email ?? '',
          'name': response.user!.userMetadata?['name'] ?? '',
        }, response.session!.accessToken);

        Get.offNamed(AppRoutes.main);
      } on AuthException catch (e) {
        Get.snackbar(
          'Login Failed',
          e.message,
          snackPosition: SnackPosition.BOTTOM,
        );
      } catch (e) {
        Get.snackbar(
          'Error',
          'Something went wrong, please try again',
          snackPosition: SnackPosition.BOTTOM,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
