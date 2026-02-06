import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquidity_tracker/controllers/workout_controller.dart';
import 'package:liquidity_tracker/controllers/workout_stats_controller.dart';

class StatsTab extends GetView<WorkoutController> {
  const StatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WorkoutController>(
      builder: (_) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _statsGrid(),
            const SizedBox(height: 20),
            _disciplineCard(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _statsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _statCard(
          title: "Workouts",
          value: controller.workoutCount.toString(),
          color: Colors.green,
          icon: Icons.fitness_center,
        ),
        _statCard(
          title: "Missed",
          value: controller.missedCount.toString(),
          color: Colors.red,
          icon: Icons.close,
        ),
        _statCard(
          title: "Rest Days",
          value: controller.restCount.toString(),
          color: Colors.blue,
          icon: Icons.nightlight_round,
        ),
        _statCard(
          title: "Streak",
          value: controller.currentStreak.toString(),
          color: Colors.orange,
          icon: Icons.local_fire_department,
        ),
      ],
    );
  }

  Widget _disciplineCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Discipline",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "${controller.disciplinePercent}%",
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: controller.disciplinePercent / 100,
              minHeight: 8,
              borderRadius: BorderRadius.circular(10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(title, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}
