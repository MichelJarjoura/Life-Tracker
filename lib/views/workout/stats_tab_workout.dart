import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:liquidity_tracker/controllers/workout_controller.dart';

class StatsTab extends StatelessWidget {
  final WorkoutController controller = Get.find();

  StatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final now = DateTime.now();
      final totalWorkouts = controller.getTotalWorkoutsInMonth(
        now.year,
        now.month,
      );
      final missedDays = controller.getMissedDaysInMonth(now.year, now.month);
      final consistency = controller.getConsistencyPercentage();
      final streak = controller.getCurrentStreak();
      final muscleFrequency = controller.getMuscleFrequencyThisMonth();

      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Month Overview
              Text(
                'Current Month Overview',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[900],
                ),
              ),
              const SizedBox(height: 16),

              // Stats Cards
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Workouts',
                      totalWorkouts.toString(),
                      Icons.fitness_center,
                      Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Missed Days',
                      missedDays.toString(),
                      Icons.event_busy,
                      Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Consistency',
                      '${consistency.toStringAsFixed(1)}%',
                      Icons.trending_up,
                      Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Current Streak',
                      '$streak ${streak == 1 ? 'day' : 'days'}',
                      Icons.local_fire_department,
                      Colors.purple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Muscles Worked This Week
              Text(
                'This Week\'s Muscle Groups',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[900],
                ),
              ),
              const SizedBox(height: 12),

              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: controller.availableMuscles.map((muscle) {
                      final worked = controller.wasMuscleWorkedThisWeek(muscle);
                      return Chip(
                        label: Text(muscle),
                        avatar: Icon(
                          worked ? Icons.check_circle : Icons.cancel,
                          size: 18,
                          color: worked ? Colors.green : Colors.red,
                        ),
                        backgroundColor: worked
                            ? Colors.green[50]
                            : Colors.red[50],
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Muscle Frequency Chart
              Text(
                'Muscle Group Frequency (This Month)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[900],
                ),
              ),
              const SizedBox(height: 12),

              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    height: 250,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY:
                            (muscleFrequency.values.isEmpty
                                    ? 10
                                    : muscleFrequency.values.reduce(
                                            (a, b) => a > b ? a : b,
                                          ) +
                                          2)
                                .toDouble(),
                        barTouchData: BarTouchData(
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              return BarTooltipItem(
                                '${controller.availableMuscles[group.x]}\n${rod.toY.round()} times',
                                const TextStyle(color: Colors.white),
                              );
                            },
                          ),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                if (value.toInt() >=
                                    controller.availableMuscles.length) {
                                  return const Text('');
                                }
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    controller.availableMuscles[value.toInt()]
                                        .substring(0, 3),
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  value.toInt().toString(),
                                  style: const TextStyle(fontSize: 10),
                                );
                              },
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
                        barGroups: List.generate(
                          controller.availableMuscles.length,
                          (index) => BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY:
                                    muscleFrequency[controller
                                            .availableMuscles[index]]!
                                        .toDouble(),
                                color: Colors.purple[700],
                                width: 20,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Insights
              // Text(
              //   'Insights & Recommendations',
              //   style: TextStyle(
              //     fontSize: 18,
              //     fontWeight: FontWeight.bold,
              //     color: Colors.purple[900],
              //   ),
              //),
              const SizedBox(height: 12),

              // _buildInsightCard(
              //   totalWorkouts,
              //   missedDays,
              //   consistency,
              //   streak,
              //   muscleFrequency,
              // ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  //   Widget _buildInsightCard(
  //     int totalWorkouts,
  //     int missedDays,
  //     double consistency,
  //     int streak,
  //     Map<String, int> muscleFrequency,
  //   ) {
  //     List<String> insights = [];

  //     // Consistency insights
  //     if (consistency >= 80) {
  //       insights.add('🔥 Excellent consistency! You\'re crushing it!');
  //     } else if (consistency >= 60) {
  //       insights.add('💪 Good consistency! Keep pushing forward.');
  //     } else if (consistency >= 40) {
  //       insights.add('⚠️ Try to maintain more consistency for better results.');
  //     } else {
  //       insights.add('📈 Focus on building a consistent routine.');
  //     }

  //     // Streak insights
  //     if (streak >= 7) {
  //       insights.add('🏆 Amazing streak! You\'re on fire!');
  //     } else if (streak >= 3) {
  //       insights.add('✨ Great streak going! Don\'t break it!');
  //     } else if (streak == 0 && totalWorkouts > 0) {
  //       insights.add('🎯 Start a new streak today!');
  //     }

  //     // Muscle balance insights
  //     final maxFreq = muscleFrequency.values.isEmpty
  //         ? 0
  //         : muscleFrequency.values.reduce((a, b) => a > b ? a : b);
  //     final minFreq = muscleFrequency.values.isEmpty
  //         ? 0
  //         : muscleFrequency.values.reduce((a, b) => a < b ? a : b);

  //     if (maxFreq - minFreq > 3) {
  //       final neglectedMuscles = muscleFrequency.entries
  //           .where((e) => e.value < maxFreq - 2)
  //           .map((e) => e.key)
  //           .toList();
  //       if (neglectedMuscles.isNotEmpty) {
  //         insights.add('⚖️ Consider working: ${neglectedMuscles.join(', ')}');
  //       }
  //     } else if (totalWorkouts > 5) {
  //       insights.add('✅ Great muscle group balance!');
  //     }

  //     // Workout frequency insights
  //     if (totalWorkouts >= 20) {
  //       insights.add('🌟 Outstanding! You\'re a gym warrior!');
  //     } else if (totalWorkouts >= 12) {
  //       insights.add('💯 Solid month of training!');
  //     } else if (totalWorkouts < 8 && DateTime.now().day > 15) {
  //       insights.add('💡 Try to increase your workout frequency.');
  //     }

  //     return Card(
  //       color: Colors.blue[50],
  //       elevation: 2,
  //       child: Padding(
  //         padding: const EdgeInsets.all(16.0),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: insights.map((insight) {
  //             return Padding(
  //               padding: const EdgeInsets.symmetric(vertical: 4.0),
  //               child: Row(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   const SizedBox(width: 8),
  //                   Expanded(
  //                     child: Text(insight, style: const TextStyle(fontSize: 14)),
  //                   ),
  //                 ],
  //               ),
  //             );
  //           }).toList(),
  //         ),
  //       ),
  //     );
  //   }
  // }
}
