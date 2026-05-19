import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_theme.dart';
import '../../controllers/workout_controller.dart';
import 'calendar_tab_workout.dart';
import 'stats_tab_workout.dart';

class WorkoutScreen extends StatelessWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<WorkoutController>();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Tab bar ────────────────────────────────────────────────────
            Obx(
              () => Container(
                color: AppColors.surface,
                child: Row(
                  children: [
                    _Tab(
                      label: 'Calendar',
                      icon: Icons.calendar_month_outlined,
                      activeIcon: Icons.calendar_month_rounded,
                      selected: ctrl.selectedTabIndex.value == 0,
                      onTap: () => ctrl.toggleTab(0),
                    ),
                    _Tab(
                      label: 'Stats',
                      icon: Icons.bar_chart_outlined,
                      activeIcon: Icons.bar_chart_rounded,
                      selected: ctrl.selectedTabIndex.value == 1,
                      onTap: () => ctrl.toggleTab(1),
                    ),
                  ],
                ),
              ),
            ),

            // ── Content ────────────────────────────────────────────────────
            Expanded(
              child: Obx(
                () => IndexedStack(
                  index: ctrl.selectedTabIndex.value,
                  children: const [CalendarTab(), StatsTab()],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final IconData icon, activeIcon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: selected ? AppColors.accentLight : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                selected ? activeIcon : icon,
                size: 18,
                color: selected ? AppColors.accentLight : AppColors.textMuted,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: selected ? AppColors.accentLight : AppColors.textMuted,
                  fontSize: 14,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
