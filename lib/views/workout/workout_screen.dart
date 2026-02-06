import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:liquidity_tracker/controllers/workout_controller.dart';
import 'package:liquidity_tracker/views/workout/calendar_tab_workout.dart';
import 'package:liquidity_tracker/views/workout/stats_tab_workout.dart';

class WorkoutScreen extends StatelessWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WorkoutController>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            /// TOP Navigation Bar
            Obx(
              () => NavigationBar(
                selectedIndex: controller.selectedTabIndex.value,
                onDestinationSelected: controller.toggleTab,
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.calendar_month_outlined),
                    selectedIcon: Icon(Icons.calendar_month),
                    label: "Calendar",
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.bar_chart_outlined),
                    selectedIcon: Icon(Icons.bar_chart),
                    label: "Stats",
                  ),
                ],
              ),
            ),

            /// TAB CONTENT
            Expanded(
              child: Obx(
                () => IndexedStack(
                  index: controller.selectedTabIndex.value,
                  children: const [CalendarTabWorkout(), StatsTab()],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
