import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:liquidity_tracker/controllers/auth_controller.dart';
import 'package:liquidity_tracker/routes/app_routes.dart';
import 'package:liquidity_tracker/services/dio_services.dart';

class LoginController extends GetxController {
  // Form key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final authController = Get.find<AuthController>();

  // Text controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final DioServices dioServices = DioServices();

  var isLoading = false.obs;

  Future<void> submitLogin() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      try {
        // Simulate network delay
        await Future.delayed(const Duration(seconds: 1));

        // Hardcoded demo credentials
        if (emailController.text == 'demo@example.com' &&
            passwordController.text == 'password123') {
          await authController.saveSession({
            'name': 'Demo User',
            'email': 'demo@example.com',
          }, 'demo_token_123');
          Get.offNamed(AppRoutes.main);
        } else {
          Get.snackbar(
            'Error',
            'Invalid email or password',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } finally {
        isLoading.value = false;
      }
    }
  }

  @override
  void onClose() {
    // Dispose controllers when controller is removed
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
