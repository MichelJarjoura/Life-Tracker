import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquidity_tracker/views/study_screen.dart';
import '../constants/app_theme.dart';
import '../controllers/auth_controller.dart';
import '../controllers/navbar_controller.dart';
import '../routes/app_routes.dart';
import 'expenses_screen.dart';
import 'workout/workout_screen.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = Get.find<NavBarController>();
    final auth = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: _AppBar(nav: nav, auth: auth),
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

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({required this.nav, required this.auth});
  final NavBarController nav;
  final AuthController auth;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              // Avatar / Profile icon
              Container(
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

              // Auth button
              Obx(
                () => auth.isLoggedIn.value
                    ? IconButton(
                        icon: const Icon(
                          Icons.logout_rounded,
                          size: 20,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () => _confirmLogout(auth),
                        tooltip: 'Logout',
                      )
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
      ),
    );
  }

  void _confirmLogout(AuthController auth) {
    Get.dialog(
      AlertDialog(
        title: const Text('Sign out?'),
        content: const Text(
          'You will need to sign in again to sync your data.',
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              auth.logout();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.expense),
            child: const Text('Sign out'),
          ),
        ],
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
    return Container(
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
    );
  }
}
