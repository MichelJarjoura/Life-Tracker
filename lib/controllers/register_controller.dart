import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquidity_tracker/controllers/auth_controller.dart';
import 'package:liquidity_tracker/routes/app_routes.dart';
import 'package:liquidity_tracker/services/dio_services.dart';

class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final authController = Get.find<AuthController>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final DioServices dioServices = DioServices();

  var isLoading = false.obs;

  Future<void> submitRegister() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      try {
        await Future.delayed(const Duration(seconds: 1));

        await authController.saveSession({
          'name': nameController.text,
          'email': emailController.text,
        }, 'demo_token_123');
        Get.offNamed(AppRoutes.main);
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
