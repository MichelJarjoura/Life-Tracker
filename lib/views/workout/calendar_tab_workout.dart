import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquidity_tracker/controllers/workout_controller.dart';
import 'package:table_calendar/table_calendar.dart';

class InputTab extends StatelessWidget {
  final WorkoutController controller = Get.find();

  InputTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Calendar
            Obx(
              () => TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: controller.selectedDate.value,
                selectedDayPredicate: (day) =>
                    isSameDay(controller.selectedDate.value, day),
                onDaySelected: (selectedDay, focusedDay) {
                  controller.selectedDate.value = selectedDay;
                  final workout = controller.getWorkout(selectedDay);
                  if (workout != null) {
                    controller.selectedMuscles.value = List.from(
                      workout.musclesWorked,
                    );
                  } else {
                    controller.selectedMuscles.clear();
                  }
                },
                calendarStyle: CalendarStyle(
                  markerDecoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.blue[700],
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.blue[300],
                    shape: BoxShape.circle,
                  ),
                ),
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, events) {
                    if (controller.hasWorkout(date)) {
                      return Positioned(
                        bottom: 1,
                        child: Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    }
                    return null;
                  },
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Selected Date Display
            Obx(
              () => Text(
                'Selected: ${controller.selectedDate.value.toString().split(' ')[0]}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Muscle Groups
            const Text(
              'Select Muscles Worked:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Obx(
              () => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: controller.availableMuscles.map((muscle) {
                  final isSelected = controller.selectedMuscles.contains(
                    muscle,
                  );
                  return FilterChip(
                    label: Text(muscle),
                    selected: isSelected,
                    onSelected: (selected) {
                      controller.toggleMuscle(muscle);
                    },
                    selectedColor: Colors.blue[300],
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Add Workout Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => controller.addWorkout(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save Workout',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Workout Preview for Selected Date
            Obx(() {
              final workout = controller.getWorkout(
                controller.selectedDate.value,
              );
              if (workout != null) {
                return Card(
                  color: Colors.green[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Workout on this date:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: workout.musclesWorked.map((muscle) {
                            return Chip(
                              label: Text(muscle),
                              backgroundColor: Colors.green[200],
                              labelStyle: const TextStyle(fontSize: 12),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}
