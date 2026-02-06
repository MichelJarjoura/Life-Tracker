import 'package:flutter/material.dart';
import 'package:liquidity_tracker/controllers/workout_controller.dart';
import 'package:liquidity_tracker/widgets/action_buttons.dart';
import 'package:get/get.dart';

class ActivityButtons extends GetView<WorkoutController> {
  const ActivityButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Log today's activity:",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            actionButton(
              label: "Workout",
              color: Colors.green,
              icon: Icons.check_circle,
              onTap: () => controller.logActivity(DayStatus.workout),
            ),
            actionButton(
              label: "Missed",
              color: Colors.red,
              icon: Icons.close,
              onTap: () => controller.logActivity(DayStatus.missed),
            ),
            actionButton(
              label: "Rest Day",
              color: Colors.blue,
              icon: Icons.nightlight_round,
              onTap: () => controller.logActivity(DayStatus.rest),
            ),
          ],
        ),
      ],
    );
  }
}
