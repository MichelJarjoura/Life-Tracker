import 'package:get/get.dart';
import 'package:dio/dio.dart';
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
      final email = emailController.text;
      final password = passwordController.text;

      try {
        final response = await dioServices.dio.post(
          '/login',
          data: {'email': email, 'password': password},
        );
        Get.snackbar(
          "Success",
          response.data['message'] ?? "Login successful",
          snackPosition: SnackPosition.BOTTOM,
        );

        authController.isLoggedin.value = true;

        authController.saveUser(response.data['user'], response.data['token']);

        Get.offNamed(AppRoutes.main);
      } on DioException catch (e) {
        emailController.text = '';
        passwordController.text = '';

        Get.snackbar(
          "Error",
          e.response?.data['message'] ?? 'Login failed',
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
    // Dispose controllers when controller is removed
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
