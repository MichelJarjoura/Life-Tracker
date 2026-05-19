import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../constants/app_theme.dart';
import '../../controllers/workout_controller.dart';

class StatsTab extends StatelessWidget {
  const StatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<WorkoutController>();

    return Obx(() {
      final now = DateTime.now();
      final total = ctrl.getTotalWorkoutsInMonth(now.year, now.month);
      final missed = ctrl.getMissedDaysInMonth(now.year, now.month);
      final pct = ctrl.getConsistencyPercentage();
      final streak = ctrl.getCurrentStreak();
      final muscleFreq = ctrl.getMuscleFrequencyThisMonth();

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Month summary ──────────────────────────────────────────────
            _SectionTitle('This Month'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    label: 'Workouts',
                    value: '$total',
                    icon: Icons.fitness_center_rounded,
                    color: AppColors.income,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatCard(
                    label: 'Rest Days',
                    value: '$missed',
                    icon: Icons.event_busy_outlined,
                    color: AppColors.expense,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    label: 'Consistency',
                    value: '${pct.toStringAsFixed(0)}%',
                    icon: Icons.trending_up_rounded,
                    color: AppColors.warning,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatCard(
                    label: 'Streak',
                    value: '$streak ${streak == 1 ? 'day' : 'days'}',
                    icon: Icons.local_fire_department_rounded,
                    color: AppColors.accentLight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ── Consistency progress ───────────────────────────────────────
            _SectionTitle('Monthly Consistency'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Progress',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        '${pct.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          color: AppColors.accentLight,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    child: LinearProgressIndicator(
                      value: (pct / 100).clamp(0.0, 1.0),
                      minHeight: 8,
                      backgroundColor: AppColors.border,
                      valueColor: AlwaysStoppedAnimation(
                        pct >= 80
                            ? AppColors.income
                            : pct >= 50
                            ? AppColors.warning
                            : AppColors.expense,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── This week's muscles ────────────────────────────────────────
            _SectionTitle("This Week's Muscles"),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.border),
              ),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: WorkoutController.availableMuscles.map((m) {
                  final worked = ctrl.wasMuscleWorkedThisWeek(m);
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: worked
                          ? AppColors.income.withOpacity(0.1)
                          : AppColors.surfaceAlt,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      border: Border.all(
                        color: worked
                            ? AppColors.income.withOpacity(0.4)
                            : AppColors.border,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          worked ? Icons.check_rounded : Icons.remove_rounded,
                          size: 13,
                          color: worked
                              ? AppColors.income
                              : AppColors.textMuted,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          m,
                          style: TextStyle(
                            color: worked
                                ? AppColors.income
                                : AppColors.textMuted,
                            fontSize: 12,
                            fontWeight: worked
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // ── Muscle frequency chart ─────────────────────────────────────
            _SectionTitle('Muscle Frequency (This Month)'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.fromLTRB(12, 20, 20, 8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.border),
              ),
              child: SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY:
                        (muscleFreq.values.isEmpty
                                ? 5
                                : muscleFreq.values.reduce(
                                        (a, b) => a > b ? a : b,
                                      ) +
                                      2)
                            .toDouble(),
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        tooltipBorderRadius: BorderRadius.circular(8),
                        getTooltipItem: (group, _, rod, __) => BarTooltipItem(
                          '${WorkoutController.availableMuscles[group.x]}\n'
                          '${rod.toY.round()}×',
                          const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (v, _) {
                            final idx = v.toInt();
                            if (idx >=
                                WorkoutController.availableMuscles.length) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                WorkoutController.availableMuscles[idx]
                                    .substring(0, 3),
                                style: const TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 10,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          getTitlesWidget: (v, _) => Text(
                            v.toInt().toString(),
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (_) =>
                          const FlLine(color: AppColors.border, strokeWidth: 1),
                    ),
                    barGroups: List.generate(
                      WorkoutController.availableMuscles.length,
                      (i) => BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY:
                                (muscleFreq[WorkoutController
                                            .availableMuscles[i]] ??
                                        0)
                                    .toDouble(),
                            color: AppColors.accentLight,
                            width: 18,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY:
                                  (muscleFreq.values.isEmpty
                                          ? 5
                                          : muscleFreq.values.reduce(
                                                  (a, b) => a > b ? a : b,
                                                ) +
                                                2)
                                      .toDouble(),
                              color: AppColors.surfaceAlt,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      );
    });
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      color: AppColors.textPrimary,
      fontSize: 16,
      fontWeight: FontWeight.w700,
    ),
  );
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
  final String label, value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.md),
      border: Border.all(color: AppColors.border),
    ),
    child: Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
        ),
      ],
    ),
  );
}
