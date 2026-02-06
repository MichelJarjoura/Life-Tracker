import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';
import 'package:liquidity_tracker/controllers/workout_controller.dart';

class CalendarCard extends GetView<WorkoutController> {
  const CalendarCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WorkoutController>(
      builder: (c) => Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: TableCalendar(
            firstDay: DateTime.utc(2023, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: c.focusedDay,

            selectedDayPredicate: (day) => isSameDay(c.selectedDay, day),

            onDaySelected: c.selectDay,

            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),

            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              selectedDecoration: const BoxDecoration(
                color: Colors.purple,
                shape: BoxShape.circle,
              ),
            ),

            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                final color = c.getStatusColor(day);
                if (color == Colors.transparent) return null;

                return Positioned(
                  bottom: 4,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
