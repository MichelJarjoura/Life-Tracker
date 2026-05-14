import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../controllers/auth_controller.dart';
import '../routes/app_routes.dart';

class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final authController = Get.find<AuthController>();
  final _supabase = Supabase.instance.client;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;

  Future<void> submitRegister() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      try {
        final response = await _supabase.auth.signUp(
          email: emailController.text.trim(),
          password: passwordController.text,
          data: {'name': nameController.text.trim()},
        );

        if (response.user == null) {
          Get.snackbar(
            'Error',
            'Registration failed, please try again',
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }

        await authController.saveSession({
          'id': response.user!.id,
          'email': response.user!.email ?? '',
          'name': nameController.text.trim(),
        }, response.session!.accessToken);

        Get.offNamed(AppRoutes.main);
      } on AuthException catch (e) {
        Get.snackbar(
          'Registration Failed',
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
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
