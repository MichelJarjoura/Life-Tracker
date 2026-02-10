import 'package:get/get.dart';
import 'package:liquidity_tracker/controllers/auth_controller.dart';
import 'package:liquidity_tracker/controllers/transaction_controller.dart';
import 'package:liquidity_tracker/controllers/navbar_controller.dart';
import 'package:liquidity_tracker/controllers/workout_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NavBarController(), permanent: true);
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<WorkoutController>(WorkoutController(), permanent: true);
    Get.put<TransactionController>(TransactionController(), permanent: true);
  }
}
