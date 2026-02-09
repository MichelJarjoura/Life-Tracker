import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/workout_day.dart';

class WorkoutController extends GetxController {
  var workoutDays = <WorkoutDay>[].obs;
  var selectedDate = DateTime.now().obs;
  var selectedMuscles = <String>[].obs;

  var selectedTabIndex = 0.obs;

  void toggleTab(index) {
    selectedTabIndex.value = index;
  }

  final List<String> availableMuscles = [
    'Chest',
    'Back',
    'Shoulders',
    'Biceps',
    'Triceps',
    'Legs',
    'Abs',
    'Cardio',
    'forearms',
  ];

  @override
  void onInit() {
    super.onInit();
    loadWorkouts();
  }

  // Load workouts from shared preferences
  Future<void> loadWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? workoutsJson = prefs.getString('workouts');
    if (workoutsJson != null) {
      final List<dynamic> decoded = jsonDecode(workoutsJson);
      workoutDays.value = decoded
          .map((json) => WorkoutDay.fromJson(json))
          .toList();
    }
  }

  // Save workouts to shared preferences
  Future<void> saveWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(
      workoutDays.map((w) => w.toJson()).toList(),
    );
    await prefs.setString('workouts', encoded);
  }

  // Toggle muscle selection
  void toggleMuscle(String muscle) {
    if (selectedMuscles.contains(muscle)) {
      selectedMuscles.remove(muscle);
    } else {
      selectedMuscles.add(muscle);
    }
  }

  // Add workout for selected date
  void addWorkout() {
    if (selectedMuscles.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select at least one muscle group',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Remove existing workout for this date if any
    workoutDays.removeWhere(
      (workout) =>
          workout.date.year == selectedDate.value.year &&
          workout.date.month == selectedDate.value.month &&
          workout.date.day == selectedDate.value.day,
    );

    // Add new workout
    workoutDays.add(
      WorkoutDay(
        date: selectedDate.value,
        musclesWorked: List.from(selectedMuscles),
      ),
    );

    saveWorkouts();
    selectedMuscles.clear();

    Get.snackbar(
      'Success',
      'Workout added successfully!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void removeWorkout() {
    workoutDays.removeWhere((workout) => workout.date == selectedDate.value);
    saveWorkouts();
  }

  // Check if a date has a workout
  bool hasWorkout(DateTime date) {
    return workoutDays.any(
      (workout) =>
          workout.date.year == date.year &&
          workout.date.month == date.month &&
          workout.date.day == date.day,
    );
  }

  // Get workout for a specific date
  WorkoutDay? getWorkout(DateTime date) {
    try {
      return workoutDays.firstWhere(
        (workout) =>
            workout.date.year == date.year &&
            workout.date.month == date.month &&
            workout.date.day == date.day,
      );
    } catch (e) {
      return null;
    }
  }

  // Get workouts for a specific month
  List<WorkoutDay> getWorkoutsForMonth(int year, int month) {
    return workoutDays
        .where(
          (workout) => workout.date.year == year && workout.date.month == month,
        )
        .toList();
  }

  // Get total workouts for a month
  int getTotalWorkoutsInMonth(int year, int month) {
    return getWorkoutsForMonth(year, month).length;
  }

  // Get missed days in a month (excluding future dates)
  int getMissedDaysInMonth(int year, int month) {
    final now = DateTime.now();
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final workoutDaysInMonth = getTotalWorkoutsInMonth(year, month);

    // Calculate how many days have passed in the month
    int daysPassed;
    if (year == now.year && month == now.month) {
      daysPassed = now.day;
    } else if (DateTime(year, month).isAfter(now)) {
      return 0; // Future month
    } else {
      daysPassed = daysInMonth;
    }

    return daysPassed - workoutDaysInMonth;
  }

  // Check if muscle was worked this week
  bool wasMuscleWorkedThisWeek(String muscle) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    return workoutDays.any((workout) {
      final isInWeek =
          workout.date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
          workout.date.isBefore(endOfWeek.add(const Duration(days: 1)));
      return isInWeek && workout.musclesWorked.contains(muscle);
    });
  }

  // Get muscle frequency in current month
  Map<String, int> getMuscleFrequencyThisMonth() {
    final now = DateTime.now();
    final workoutsThisMonth = getWorkoutsForMonth(now.year, now.month);

    Map<String, int> frequency = {};
    for (var muscle in availableMuscles) {
      frequency[muscle] = 0;
    }

    for (var workout in workoutsThisMonth) {
      for (var muscle in workout.musclesWorked) {
        frequency[muscle] = (frequency[muscle] ?? 0) + 1;
      }
    }

    return frequency;
  }

  // Get workout consistency percentage for current month
  double getConsistencyPercentage() {
    final now = DateTime.now();
    final daysPassed = now.day;
    final workouts = getTotalWorkoutsInMonth(now.year, now.month);

    if (daysPassed == 0) return 0.0;
    return (workouts / daysPassed) * 100;
  }

  // Get current streak
  int getCurrentStreak() {
    if (workoutDays.isEmpty) return 0;

    final sortedWorkouts = workoutDays.toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    int streak = 0;
    DateTime checkDate = DateTime.now();

    for (var workout in sortedWorkouts) {
      final dayDifference = checkDate.difference(workout.date).inDays;

      if (dayDifference <= 1) {
        streak++;
        checkDate = workout.date;
      } else {
        break;
      }
    }

    return streak;
  }
}
