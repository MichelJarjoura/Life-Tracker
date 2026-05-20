import 'package:get/get.dart';
import 'package:liquidity_tracker/core/bindings/main_binding.dart';
import 'package:liquidity_tracker/core/bindings/login_binding.dart';
import 'package:liquidity_tracker/core/bindings/register_binding.dart';
import 'package:liquidity_tracker/core/screens/main_view.dart';
import 'package:liquidity_tracker/features/auth/presentation/widgets/profile_view.dart';
import 'package:liquidity_tracker/features/auth/presentation/screens/login_screen.dart';
import 'package:liquidity_tracker/features/auth/presentation/screens/register_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => LoginScreen(),
      binding: LoginBinding(), // ← was missing
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => RegisterScreen(),
      binding: RegisterBinding(), // ← was missing
    ),
    GetPage(
      name: AppRoutes.main,
      page: () => MainView(),
      binding: MainBinding(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileScreen(),
    ),
  ];
}
