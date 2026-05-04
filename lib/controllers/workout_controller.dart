import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/workout_day.dart';
import '../constants/storage_keys.dart';

class WorkoutController extends GetxController {
  // ─── State ──────────────────────────────────────────────────────────────────
  final workoutDays = <WorkoutDay>[].obs;
  final selectedDate = DateTime.now().obs;
  final selectedMuscles = <String>[].obs;
  final selectedTabIndex = 0.obs;

  static const availableMuscles = [
    'Chest',
    'Back',
    'Shoulders',
    'Biceps',
    'Triceps',
    'Legs',
    'Abs',
    'Cardio',
    'Forearms',
  ];

  // ─── Helpers ────────────────────────────────────────────────────────────────
  /// Strip time component so all comparisons are date-only.
  static DateTime _normalize(DateTime d) => DateTime(d.year, d.month, d.day);

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  // ─── Persistence ────────────────────────────────────────────────────────────
  Future<void> loadWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(StorageKeys.workouts);
    if (json != null) {
      final list = jsonDecode(json) as List<dynamic>;
      workoutDays.value = list
          .map((e) => WorkoutDay.fromJson(e as Map<String, dynamic>))
          .toList();
    }
  }

  Future<void> _saveWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(workoutDays.map((w) => w.toJson()).toList());
    await prefs.setString(StorageKeys.workouts, encoded);
  }

  // ─── Tab ────────────────────────────────────────────────────────────────────
  void toggleTab(int index) => selectedTabIndex.value = index;

  // ─── Muscles ────────────────────────────────────────────────────────────────
  void toggleMuscle(String muscle) {
    selectedMuscles.contains(muscle)
        ? selectedMuscles.remove(muscle)
        : selectedMuscles.add(muscle);
  }

  // ─── CRUD ───────────────────────────────────────────────────────────────────
  void addWorkout() {
    if (selectedMuscles.isEmpty) {
      Get.snackbar(
        'No muscles selected',
        'Pick at least one muscle group to log.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Replace any existing entry for the same date
    workoutDays.removeWhere((w) => _sameDay(w.date, selectedDate.value));

    workoutDays.add(
      WorkoutDay(
        date: selectedDate.value,
        musclesWorked: List<String>.from(selectedMuscles),
      ),
    );

    _saveWorkouts();
    selectedMuscles.clear();

    Get.snackbar(
      'Workout saved',
      'Your session has been logged.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void removeWorkout() {
    // ✅ Fixed: was comparing full DateTime objects (including time)
    workoutDays.removeWhere((w) => _sameDay(w.date, selectedDate.value));
    _saveWorkouts();
  }

  // ─── Queries ────────────────────────────────────────────────────────────────
  bool hasWorkout(DateTime date) =>
      workoutDays.any((w) => _sameDay(w.date, date));

  WorkoutDay? getWorkout(DateTime date) {
    try {
      return workoutDays.firstWhere((w) => _sameDay(w.date, date));
    } catch (_) {
      return null;
    }
  }

  List<WorkoutDay> getWorkoutsForMonth(int year, int month) => workoutDays
      .where((w) => w.date.year == year && w.date.month == month)
      .toList();

  int getTotalWorkoutsInMonth(int year, int month) =>
      getWorkoutsForMonth(year, month).length;

  int getMissedDaysInMonth(int year, int month) {
    final now = DateTime.now();
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final worked = getTotalWorkoutsInMonth(year, month);

    int daysPassed;
    if (year == now.year && month == now.month) {
      daysPassed = now.day;
    } else if (DateTime(year, month).isAfter(now)) {
      return 0;
    } else {
      daysPassed = daysInMonth;
    }

    return (daysPassed - worked).clamp(0, daysPassed);
  }

  bool wasMuscleWorkedThisWeek(String muscle) {
    final now = DateTime.now();
    final startOfWeek = _normalize(
      now.subtract(Duration(days: now.weekday - 1)),
    );
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    return workoutDays.any((w) {
      final d = _normalize(w.date);
      return !d.isBefore(startOfWeek) &&
          !d.isAfter(endOfWeek) &&
          w.musclesWorked.contains(muscle);
    });
  }

  Map<String, int> getMuscleFrequencyThisMonth() {
    final now = DateTime.now();
    final workouts = getWorkoutsForMonth(now.year, now.month);
    final freq = {for (final m in availableMuscles) m: 0};

    for (final w in workouts) {
      for (final m in w.musclesWorked) {
        if (freq.containsKey(m)) freq[m] = freq[m]! + 1;
      }
    }
    return freq;
  }

  double getConsistencyPercentage() {
    final now = DateTime.now();
    final daysPassed = now.day;
    if (daysPassed == 0) return 0;
    return (getTotalWorkoutsInMonth(now.year, now.month) / daysPassed * 100)
        .clamp(0, 100);
  }

  /// ✅ Fixed streak: normalise both sides of the comparison.
  int getCurrentStreak() {
    if (workoutDays.isEmpty) return 0;

    final sorted = workoutDays.toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    int streak = 0;
    DateTime checkDate = _normalize(DateTime.now());

    for (final workout in sorted) {
      final workoutDate = _normalize(workout.date);
      final diff = checkDate.difference(workoutDate).inDays;

      if (diff == 0 || diff == 1) {
        streak++;
        checkDate = workoutDate;
      } else {
        break;
      }
    }

    return streak;
  }

  // ─── Lifecycle ──────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    loadWorkouts();
  }
}
