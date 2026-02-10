import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../controllers/study_controller.dart';
import '../constants/app_theme.dart';

class AddSessionDialog extends StatefulWidget {
  final StudyController controller;

  const AddSessionDialog({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<AddSessionDialog> createState() => _AddSessionDialogState();
}

class _AddSessionDialogState extends State<AddSessionDialog> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _subjectController.dispose();
    _durationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.cardBackground,
      title: const Text('Add Study Session'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _subjectController,
              decoration: const InputDecoration(
                labelText: 'Subject',
                hintText: 'e.g., Mathematics',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _durationController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'Duration (minutes)',
                hintText: 'e.g., 45',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                hintText: 'What did you study?',
                alignLabelWithHint: true,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _addSession,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryPurple,
          ),
          child: const Text('Add'),
        ),
      ],
    );
  }

  void _addSession() {
    if (_subjectController.text.isNotEmpty && _durationController.text.isNotEmpty) {
      final duration = int.tryParse(_durationController.text);
      if (duration != null && duration > 0) {
        widget.controller.addSession(
          _subjectController.text,
          duration,
          notes: _notesController.text.isNotEmpty ? _notesController.text : null,
        );
        Navigator.pop(context);
      }
    }
  }
}
