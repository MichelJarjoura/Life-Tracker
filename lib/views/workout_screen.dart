import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:liquidity_tracker/controllers/workout_controller.dart';
import 'package:liquidity_tracker/views/calendar_tab_workout.dart';
import 'package:liquidity_tracker/views/stats_tab_workout.dart';

class WorkoutScreen extends StatelessWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WorkoutController>();
    return SingleChildScrollView(
      child: Obx(
        () => Column(
          children: [
            NavigationBar(
              onDestinationSelected: (index) => controller.toggleTab(index),
              destinations: [
                NavigationDestination(
                  icon: Icon(Icons.calendar_month),
                  selectedIcon: Icon(Icons.calendar_month_outlined),
                  label: "Calendar",
                ),
                NavigationDestination(
                  icon: Icon(Icons.bar_chart),
                  selectedIcon: Icon(Icons.bar_chart_outlined),
                  label: "Stats",
                ),
              ],
              selectedIndex: controller.selectedTabIndex.value,
            ),
            IndexedStack(
              index: controller.selectedTabIndex.value,
              children: [CalendarTab(), StatsTab()],
            ),
          ],
        ),
      ),
    );
  }
}
