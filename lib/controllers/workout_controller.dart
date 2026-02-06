import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum DayStatus { workout, missed, rest }

class WorkoutController extends GetxController {
  var selectedTabIndex = 0.obs;

  void toggleTab(int index) {
    selectedTabIndex.value = index;
  }

  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;

  final Map<DateTime, DayStatus> activityMap = {};

  /// Normalize date (VERY IMPORTANT)
  DateTime normalize(DateTime day) => DateTime(day.year, day.month, day.day);

  void selectDay(DateTime selected, DateTime focused) {
    selectedDay = normalize(selected);
    focusedDay = focused;
    update(); // 🔥 REQUIRED
  }

  void logActivity(DayStatus status) {
    if (selectedDay == null) return;

    activityMap[selectedDay!] = status;
    update(); // 🔥 REQUIRED
  }

  Color getStatusColor(DateTime day) {
    final status = activityMap[normalize(day)];
    switch (status) {
      case DayStatus.workout:
        return Colors.green;
      case DayStatus.missed:
        return Colors.red;
      case DayStatus.rest:
        return Colors.blue;
      default:
        return Colors.transparent;
    }
  }
}
