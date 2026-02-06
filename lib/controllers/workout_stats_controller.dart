import 'package:liquidity_tracker/controllers/workout_controller.dart';

extension WorkoutStats on WorkoutController {
  int get workoutCount =>
      activityMap.values.where((s) => s == DayStatus.workout).length;

  int get missedCount =>
      activityMap.values.where((s) => s == DayStatus.missed).length;

  int get restCount =>
      activityMap.values.where((s) => s == DayStatus.rest).length;

  int get totalDays => activityMap.length;

  int get disciplinePercent {
    if (totalDays == 0) return 0;
    return ((workoutCount / totalDays) * 100).round();
  }

  int get currentStreak {
    int streak = 0;
    DateTime day = normalize(DateTime.now());

    while (true) {
      final status = activityMap[day];
      if (status == DayStatus.workout || status == DayStatus.rest) {
        streak++;
        day = day.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }
}
