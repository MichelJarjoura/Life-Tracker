import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/study_controller.dart';
import '../constants/app_theme.dart';
import 'start_timer_dialog.dart';

class TimerSection extends StatelessWidget {
  final StudyController controller;

  const TimerSection({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              controller.isTimerRunning.value 
                  ? 'Studying: ${controller.selectedSubject.value}' 
                  : 'Study Timer',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              controller.formatTime(controller.currentSeconds.value),
              style: AppTheme.timerStyle,
            ),
            const SizedBox(height: 20),
            if (!controller.isTimerRunning.value)
              ElevatedButton.icon(
                onPressed: () => _showStartTimerDialog(context),
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start Timer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryPurple,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              )
            else
              ElevatedButton.icon(
                onPressed: () => controller.stopTimer(),
                icon: const Icon(Icons.stop),
                label: const Text('Stop Timer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700],
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
          ],
        ),
      ),
    ));
  }

  void _showStartTimerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => StartTimerDialog(controller: controller),
    );
  }
}
