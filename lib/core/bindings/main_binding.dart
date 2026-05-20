import 'package:get/get.dart';
import 'package:liquidity_tracker/features/auth/controllers/auth_controller.dart';
import 'package:liquidity_tracker/core/controllers/navbar_controller.dart';
import 'package:liquidity_tracker/features/expenses/controllers/transaction_controller.dart';
import 'package:liquidity_tracker/features/workout/controllers/workout_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    // AuthController may already be registered from main(); put handles that gracefully.
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<NavBarController>(NavBarController(), permanent: true);
    Get.put<WorkoutController>(WorkoutController(), permanent: true);
    Get.put<TransactionController>(TransactionController(), permanent: true);
  }
}
