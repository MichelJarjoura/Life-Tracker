import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/study_session.dart';
import 'package:liquidity_tracker/core/theme/storage_keys.dart';

class StudyController extends GetxController {
  // ─── State ──────────────────────────────────────────────────────────────────
  final sessions = <StudySession>[].obs;
  final isTimerRunning = false.obs;
  final currentSeconds = 0.obs;
  final selectedSubject = ''.obs;

  Timer? _timer; // ✅ Proper Timer — no recursive Future.delayed

  // ─── Computed ───────────────────────────────────────────────────────────────
  int get totalStudyTime => sessions.fold(0, (sum, s) => sum + s.duration);

  int get todayStudyTime {
    final today = DateTime.now();
    return sessions
        .where(
          (s) =>
              s.date.year == today.year &&
              s.date.month == today.month &&
              s.date.day == today.day,
        )
        .fold(0, (sum, s) => sum + s.duration);
  }

  int get totalSessions => sessions.length;

  Map<String, int> get subjectBreakdown {
    final map = <String, int>{};
    for (final s in sessions) {
      map[s.subject] = (map[s.subject] ?? 0) + s.duration;
    }
    return map;
  }

  // ─── Persistence ────────────────────────────────────────────────────────────
  Future<void> _saveSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(sessions.map((s) => s.toJson()).toList());
    await prefs.setString(StorageKeys.sessions, encoded);
  }

  Future<void> loadSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(StorageKeys.sessions);
    if (json != null) {
      final list = jsonDecode(json) as List<dynamic>;
      sessions.value = list
          .map((e) => StudySession.fromJson(e as Map<String, dynamic>))
          .toList();
    }
  }

  // ─── CRUD ───────────────────────────────────────────────────────────────────
  void addSession(String subject, int durationMinutes, {String? notes}) {
    sessions.insert(
      0,
      StudySession(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        subject: subject,
        duration: durationMinutes,
        date: DateTime.now(),
        notes: notes,
      ),
    );
    _saveSessions();
  }

  void deleteSession(String id) {
    sessions.removeWhere((s) => s.id == id);
    _saveSessions();
  }

  // ─── Timer ──────────────────────────────────────────────────────────────────
  void startTimer(String subject) {
    selectedSubject.value = subject;
    isTimerRunning.value = true;
    currentSeconds.value = 0;

    // ✅ dart:async Timer.periodic — properly cancellable
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      currentSeconds.value++;
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
    isTimerRunning.value = false;

    if (currentSeconds.value > 0) {
      addSession(
        selectedSubject.value,
        (currentSeconds.value / 60).round().clamp(1, 9999),
      );
    }
    currentSeconds.value = 0;
  }

  // ─── Formatting ─────────────────────────────────────────────────────────────
  String formatTime(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    return '${h.toString().padLeft(2, '0')}:'
        '${m.toString().padLeft(2, '0')}:'
        '${s.toString().padLeft(2, '0')}';
  }

  String formatDuration(int minutes) {
    if (minutes == 0) return '0 min';
    if (minutes < 60) return '$minutes min';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return m > 0 ? '${h}h ${m}m' : '${h}h';
  }

  // ─── Lifecycle ──────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    loadSessions();
  }

  @override
  void onClose() {
    _timer?.cancel(); // ✅ Always cancel on dispose
    super.onClose();
  }
}
