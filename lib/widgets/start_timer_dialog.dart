import 'package:flutter/material.dart';
import '../controllers/study_controller.dart';
import '../constants/app_theme.dart';

class StartTimerDialog extends StatefulWidget {
  final StudyController controller;

  const StartTimerDialog({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<StartTimerDialog> createState() => _StartTimerDialogState();
}

class _StartTimerDialogState extends State<StartTimerDialog> {
  final TextEditingController _subjectController = TextEditingController();

  @override
  void dispose() {
    _subjectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.cardBackground,
      title: const Text('Start Study Timer'),
      content: TextField(
        controller: _subjectController,
        autofocus: true,
        decoration: const InputDecoration(
          labelText: 'Subject',
          hintText: 'e.g., Mathematics, Physics',
        ),
        onSubmitted: (_) => _startTimer(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _startTimer,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryPurple,
          ),
          child: const Text('Start'),
        ),
      ],
    );
  }

  void _startTimer() {
    if (_subjectController.text.isNotEmpty) {
      widget.controller.startTimer(_subjectController.text);
      Navigator.pop(context);
    }
  }
}
