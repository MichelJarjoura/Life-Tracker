import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/study_controller.dart';
import '../constants/app_theme.dart';
import '../widgets/stat_card.dart';
import '../widgets/timer_section.dart';
import '../widgets/session_card.dart';
import '../widgets/add_session_dialog.dart';
import '../widgets/empty_sessions_state.dart';

class StudyScreen extends StatelessWidget {
  const StudyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final StudyController controller = Get.put(StudyController());

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const SizedBox(height: 8),
              Center(child: Text('📚 ', style: AppTheme.headingStyle)),
              const SizedBox(height: 24),

              // Stats Cards
              Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        label: 'Today',
                        value: controller.formatDuration(
                          controller.todayStudyTime,
                        ),
                        icon: Icons.today,
                        color: AppTheme.primaryPurple,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatCard(
                        label: 'Total',
                        value: controller.formatDuration(
                          controller.totalStudyTime,
                        ),
                        icon: Icons.school,
                        color: AppTheme.secondaryPurple,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatCard(
                        label: 'Sessions',
                        value: controller.totalSessions.toString(),
                        icon: Icons.list_alt,
                        color: AppTheme.lightPurple,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Timer Section
              TimerSection(controller: controller),

              const SizedBox(height: 24),

              // Recent Sessions Header with Add Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recent Sessions', style: AppTheme.subHeadingStyle),
                  ElevatedButton.icon(
                    onPressed: () => _showAddSessionDialog(context, controller),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryPurple,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Sessions List
              Obx(() {
                if (controller.sessions.isEmpty) {
                  return const EmptySessionsState();
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.sessions.length,
                  itemBuilder: (context, index) {
                    final session = controller.sessions[index];
                    return SessionCard(
                      session: session,
                      controller: controller,
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddSessionDialog(BuildContext context, StudyController controller) {
    showDialog(
      context: context,
      builder: (context) => AddSessionDialog(controller: controller),
    );
  }
}
