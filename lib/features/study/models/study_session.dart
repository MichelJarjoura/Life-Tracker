class StudySession {
  final String id;
  final String subject;
  final int duration; // in minutes
  final DateTime date;
  final String? notes;

  StudySession({
    required this.id,
    required this.subject,
    required this.duration,
    required this.date,
    this.notes,
  });

  // Convert to JSON for potential future use (storage, API, etc.)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'duration': duration,
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }

  // Create from JSON
  factory StudySession.fromJson(Map<String, dynamic> json) {
    return StudySession(
      id: json['id'],
      subject: json['subject'],
      duration: json['duration'],
      date: DateTime.parse(json['date']),
      notes: json['notes'],
    );
  }

  // Copy with method for potential updates
  StudySession copyWith({
    String? id,
    String? subject,
    int? duration,
    DateTime? date,
    String? notes,
  }) {
    return StudySession(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      duration: duration ?? this.duration,
      date: date ?? this.date,
      notes: notes ?? this.notes,
    );
  }
}
