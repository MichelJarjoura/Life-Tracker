import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../routes/app_routes.dart';

class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();
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
        await _supabase.auth.signUp(
          email: emailController.text.trim(),
          password: passwordController.text,
          data: {'name': nameController.text.trim()},
        );

        Get.snackbar(
          'Account Created',
          'You can now sign in',
          snackPosition: SnackPosition.BOTTOM,
        );

        // ✅ Go to login after register
        Get.offAllNamed(AppRoutes.login);
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
