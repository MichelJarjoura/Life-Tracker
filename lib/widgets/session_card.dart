import 'package:flutter/material.dart';
import '../models/study_session.dart';
import '../controllers/study_controller.dart';
import '../utils/date_utils.dart' as app_date_utils;

class SessionCard extends StatelessWidget {
  final StudySession session;
  final StudyController controller;

  const SessionCard({Key? key, required this.session, required this.controller})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF9C27B0),
          child: Text(
            session.subject[0].toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        title: Text(
          session.subject,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              controller.formatDuration(session.duration),
              style: const TextStyle(color: Color(0xFFBA68C8)),
            ),
            Text(
              app_date_utils.DateUtils.formatRelativeTime(session.date),
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
            if (session.notes != null && session.notes!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                session.notes!,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _showDeleteConfirmation(context),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('Delete Session'),
        content: const Text(
          'Are you sure you want to delete this study session?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.deleteSession(session.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red[700]),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
