import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquidity_tracker/core/theme/app_theme.dart';
import 'package:liquidity_tracker/features/auth/controllers/auth_controller.dart';
import 'package:liquidity_tracker/core/controllers/navbar_controller.dart';
import 'package:liquidity_tracker/core/routes/app_routes.dart';
import 'package:liquidity_tracker/features/expenses/screens/expenses_screen.dart';
import 'package:liquidity_tracker/features/workout/presentation/screens/workout_screen.dart';
import 'package:liquidity_tracker/features/study/screens/study_screen.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = Get.find<NavBarController>();
    final auth = Get.find<AuthController>();
    final topInset = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(64 + topInset),
        child: _AppBarChrome(topInset: topInset, nav: nav, auth: auth),
      ),
      body: Obx(
        () => IndexedStack(
          index: nav.selectedIndex.value,
          children: const [ExpensesScreen(), WorkoutScreen(), StudyScreen()],
        ),
      ),
      bottomNavigationBar: _BottomNav(nav: nav),
    );
  }
}

// ─── Top App Bar ──────────────────────────────────────────────────────────────

class _AppBarChrome extends StatelessWidget {
  const _AppBarChrome({
    required this.topInset,
    required this.nav,
    required this.auth,
  });
  final double topInset;
  final NavBarController nav;
  final AuthController auth;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      padding: EdgeInsets.only(top: topInset, left: 20, right: 20),
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: 64,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar / Profile icon
            GestureDetector(
              onTap: () {
                if (auth.isLoggedIn.value) {
                  Get.toNamed(AppRoutes.profile);
                } else {
                  Get.toNamed(AppRoutes.login);
                }
              },
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accentGlow,
                  border: Border.all(color: AppColors.accent, width: 1.5),
                ),
                child: const Icon(
                  Icons.person_outline_rounded,
                  size: 18,
                  color: AppColors.accentLight,
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Title
            Expanded(
              child: Obx(
                () => Text(
                  nav.currentTitle,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ),

            // Sign in (profile avatar handles account when logged in)
            Obx(
              () => auth.isLoggedIn.value
                  ? const SizedBox.shrink()
                  : TextButton(
                      onPressed: () => Get.toNamed(AppRoutes.login),
                      child: const Text(
                        'Sign in',
                        style: TextStyle(
                          color: AppColors.accentLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Bottom Navigation ────────────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.nav});
  final NavBarController nav;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: SafeArea(
          top: false,
          child: Obx(
            () => BottomNavigationBar(
              currentIndex: nav.selectedIndex.value,
              onTap: nav.changeIndex,
              backgroundColor: Colors.transparent,
              elevation: 0,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_balance_wallet_outlined),
                  activeIcon: Icon(Icons.account_balance_wallet_rounded),
                  label: 'Expenses',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.fitness_center_outlined),
                  activeIcon: Icon(Icons.fitness_center_rounded),
                  label: 'Workout',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu_book_outlined),
                  activeIcon: Icon(Icons.menu_book_rounded),
                  label: 'Study',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
