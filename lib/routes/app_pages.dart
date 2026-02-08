import 'package:get/get.dart';
import 'package:liquidity_tracker/bindings/main_binding.dart';
import 'package:liquidity_tracker/views/main_view.dart';
import '../views/auth/login_screen.dart';
import '../views/auth/register_screen.dart';
import '../bindings/login_binding.dart';
import '../bindings/register_binding.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => RegisterScreen(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: AppRoutes.main,
      page: () => MainView(),
      binding: MainBinding(),
    ),
  ];
}
