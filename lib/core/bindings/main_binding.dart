import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/navbar_controller.dart';
import '../controllers/transaction_controller.dart';
import '../controllers/workout_controller.dart';

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
