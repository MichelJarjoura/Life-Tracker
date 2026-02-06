import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
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
      // Call API / Firebase / Backend later

      try {
        isLoading.value = true;
        final response = await dioServices.dio.post(
          '/register',
          data: {
            'name': nameController.text,
            'email': emailController.text,
            'password': passwordController.text,
            'password_confirmation': confirmPasswordController.text,
          },
        );
        Get.snackbar(
          "Success",
          response.data['message'] ?? "Registration successful",
          snackPosition: SnackPosition.BOTTOM,
        );

        authController.isLoggedin.value = true;

        authController.saveUser(response.data['user'], response.data['token']);

        Get.offNamed(AppRoutes.main);
      } on DioException catch (e) {
        Get.snackbar(
          "Error",
          e.response?.data['message'] ?? 'Registration failed',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
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
