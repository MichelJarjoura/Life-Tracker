import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../constants/app_theme.dart';
import '../../controllers/workout_controller.dart';

class CalendarTab extends StatelessWidget {
  const CalendarTab({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<WorkoutController>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Calendar ──────────────────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.border),
            ),
            child: Obx(
              () => TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: ctrl.selectedDate.value,
                selectedDayPredicate: (day) =>
                    isSameDay(ctrl.selectedDate.value, day),
                onDaySelected: (selected, focused) {
                  ctrl.selectedDate.value = selected;
                  final workout = ctrl.getWorkout(selected);
                  ctrl.selectedMuscles.value = workout != null
                      ? List<String>.from(workout.musclesWorked)
                      : [];
                },
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                  defaultTextStyle: const TextStyle(
                    color: AppColors.textSecondary,
                  ),
                  weekendTextStyle: const TextStyle(
                    color: AppColors.textSecondary,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: AppColors.accentGlow,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.accentLight),
                  ),
                  todayTextStyle: const TextStyle(color: AppColors.accentLight),
                  selectedTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (ctx, date, _) {
                    if (!ctrl.hasWorkout(date)) return null;
                    return Positioned(
                      bottom: 4,
                      child: Container(
                        width: 5,
                        height: 5,
                        decoration: const BoxDecoration(
                          color: AppColors.income,
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  },
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: AppColors.textSecondary,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: AppColors.textSecondary,
                  ),
                ),
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                  weekendStyle: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ── Selected date label ────────────────────────────────────────────
          Obx(
            () => Row(
              children: [
                const Icon(
                  Icons.event_rounded,
                  size: 16,
                  color: AppColors.textMuted,
                ),
                const SizedBox(width: 6),
                Text(
                  _formatDate(ctrl.selectedDate.value),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Muscle chips ──────────────────────────────────────────────────
          const Text(
            'Muscles worked',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),

          Obx(
            () => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: WorkoutController.availableMuscles.map((muscle) {
                final selected = ctrl.selectedMuscles.contains(muscle);
                return FilterChip(
                  label: Text(muscle),
                  selected: selected,
                  onSelected: (_) => ctrl.toggleMuscle(muscle),
                  selectedColor: AppColors.accentGlow,
                  checkmarkColor: AppColors.accentLight,
                  labelStyle: TextStyle(
                    color: selected
                        ? AppColors.accentLight
                        : AppColors.textSecondary,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    fontSize: 13,
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),

          // ── Save button ───────────────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: ctrl.addWorkout,
              icon: const Icon(Icons.save_rounded, size: 18),
              label: const Text('Save Workout'),
            ),
          ),
          const SizedBox(height: 16),

          // ── Existing workout preview ──────────────────────────────────────
          Obx(() {
            final workout = ctrl.getWorkout(ctrl.selectedDate.value);
            if (workout == null) return const SizedBox.shrink();

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.income.withOpacity(0.06),
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.income.withOpacity(0.25)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.income,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Logged workout',
                        style: TextStyle(
                          color: AppColors.income,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: ctrl.removeWorkout,
                        child: const Icon(
                          Icons.close_rounded,
                          color: AppColors.textMuted,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: workout.musclesWorked
                        .map(
                          (m) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.income.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(
                                AppRadius.pill,
                              ),
                            ),
                            child: Text(
                              m,
                              style: const TextStyle(
                                color: AppColors.income,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${weekdays[d.weekday - 1]}, ${months[d.month - 1]} ${d.day}';
  }
}
