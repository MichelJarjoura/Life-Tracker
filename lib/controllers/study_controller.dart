import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/study_session.dart';

class StudyController extends GetxController {
  // Observable list of study sessions
  var sessions = <StudySession>[].obs;

  // Timer state
  var isTimerRunning = false.obs;
  var currentSeconds = 0.obs;
  var selectedSubject = ''.obs;

  // Computed properties for statistics
  int get totalStudyTime =>
      sessions.fold(0, (sum, session) => sum + session.duration);

  void saveSession() async {
    final pref = await SharedPreferences.getInstance();
    final String encode = jsonEncode(sessions.map((m) => m.toJson()).toList());

    await pref.setString('sessions', encode);
  }

  void loadSessions() async {
    final pref = await SharedPreferences.getInstance();

    final String? sessionsJson = pref.getString('sessions');

    if (sessionsJson != null) {
      final List<dynamic> decoded = jsonDecode(sessionsJson);

      sessions.value = decoded
          .map((json) => StudySession.fromJson(json))
          .toList();
    }
  }

  int get todayStudyTime {
    final today = DateTime.now();
    return sessions
        .where(
          (session) =>
              session.date.year == today.year &&
              session.date.month == today.month &&
              session.date.day == today.day,
        )
        .fold(0, (sum, session) => sum + session.duration);
  }

  int get totalSessions => sessions.length;

  Map<String, int> get subjectBreakdown {
    Map<String, int> breakdown = {};
    for (var session in sessions) {
      breakdown[session.subject] =
          (breakdown[session.subject] ?? 0) + session.duration;
    }
    return breakdown;
  }

  // Add a new study session
  void addSession(String subject, int duration, {String? notes}) {
    final session = StudySession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      subject: subject,
      duration: duration,
      date: DateTime.now(),
      notes: notes,
    );
    sessions.insert(0, session);

    saveSession();
  }

  // Delete a session by id
  void deleteSession(String id) {
    sessions.removeWhere((session) => session.id == id);
    saveSession();
  }

  // Start the timer
  void startTimer(String subject) {
    selectedSubject.value = subject;
    isTimerRunning.value = true;
    currentSeconds.value = 0;
    _runTimer();
  }

  // Stop the timer and save session
  void stopTimer() {
    isTimerRunning.value = false;
    if (currentSeconds.value > 0) {
      addSession(selectedSubject.value, (currentSeconds.value / 60).round());
    }
    currentSeconds.value = 0;
  }

  // Timer loop
  void _runTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (isTimerRunning.value) {
        currentSeconds.value++;
        _runTimer();
      }
    });
  }

  // Format seconds to HH:MM:SS
  String formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  // Format duration in minutes to readable format
  String formatDuration(int minutes) {
    if (minutes < 60) {
      return '$minutes min';
    } else {
      int hours = minutes ~/ 60;
      int mins = minutes % 60;
      return mins > 0 ? '${hours}h ${mins}m' : '${hours}h';
    }
  }

  @override
  void onClose() {
    // Clean up timer if running
    if (isTimerRunning.value) {
      isTimerRunning.value = false;
    }
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    loadSessions();
  }
}
