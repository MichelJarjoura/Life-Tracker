import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../constants/app_theme.dart';
import '../../../../controllers/study_controller.dart';
import '../../../../models/study_session.dart';
import '../../../../utils/app_date_utils.dart';

class StudyScreen extends StatelessWidget {
  const StudyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(StudyController());

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        slivers: [
          // ── Stats row ─────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Obx(
              () => Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  children: [
                    _StatBubble(
                      label: 'Today',
                      value: ctrl.formatDuration(ctrl.todayStudyTime),
                      icon: Icons.wb_sunny_outlined,
                      color: AppColors.warning,
                    ),
                    const SizedBox(width: 10),
                    _StatBubble(
                      label: 'Total',
                      value: ctrl.formatDuration(ctrl.totalStudyTime),
                      icon: Icons.school_outlined,
                      color: AppColors.accentLight,
                    ),
                    const SizedBox(width: 10),
                    _StatBubble(
                      label: 'Sessions',
                      value: '${ctrl.totalSessions}',
                      icon: Icons.list_alt_outlined,
                      color: AppColors.info,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Timer card ────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _TimerCard(ctrl: ctrl),
            ),
          ),

          // ── Sessions header ───────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent sessions',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => _showAddDialog(context, ctrl),
                    icon: const Icon(Icons.add_rounded, size: 16),
                    label: const Text('Add'),
                  ),
                ],
              ),
            ),
          ),

          // ── Sessions list ─────────────────────────────────────────────────
          Obx(() {
            if (ctrl.sessions.isEmpty) {
              return const SliverToBoxAdapter(child: _EmptySessions());
            }
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) => _SessionTile(session: ctrl.sessions[i], ctrl: ctrl),
                childCount: ctrl.sessions.length,
              ),
            );
          }),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }
}

// ─── Stat bubble ─────────────────────────────────────────────────────────────

class _StatBubble extends StatelessWidget {
  const _StatBubble({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
  final String label, value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 17,
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
    ),
  );
}

// ─── Timer Card ──────────────────────────────────────────────────────────────

class _TimerCard extends StatelessWidget {
  const _TimerCard({required this.ctrl});
  final StudyController ctrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.border),
      ),
      child: Obx(() {
        final running = ctrl.isTimerRunning.value;
        return Column(
          children: [
            Text(
              running ? ctrl.selectedSubject.value : 'Study Timer',
              style: TextStyle(
                color: running
                    ? AppColors.accentLight
                    : AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              ctrl.formatTime(ctrl.currentSeconds.value),
              style: TextStyle(
                color: running ? AppColors.textPrimary : AppColors.textMuted,
                fontSize: 52,
                fontWeight: FontWeight.w800,
                letterSpacing: -2,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: running
                  ? ElevatedButton.icon(
                      onPressed: ctrl.stopTimer,
                      icon: const Icon(Icons.stop_rounded, size: 18),
                      label: const Text('Stop & Save'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.expense,
                      ),
                    )
                  : ElevatedButton.icon(
                      onPressed: () => _showStartTimerDialog(context),
                      icon: const Icon(Icons.play_arrow_rounded, size: 18),
                      label: const Text('Start Timer'),
                    ),
            ),
          ],
        );
      }),
    );
  }

  void _showStartTimerDialog(BuildContext context) {
    final subjectCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('What are you studying?'),
        content: TextField(
          controller: subjectCtrl,
          autofocus: true,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: const InputDecoration(hintText: 'e.g. Mathematics'),
          onSubmitted: (_) {
            if (subjectCtrl.text.trim().isNotEmpty) {
              ctrl.startTimer(subjectCtrl.text.trim());
              Navigator.pop(ctx);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (subjectCtrl.text.trim().isNotEmpty) {
                ctrl.startTimer(subjectCtrl.text.trim());
                Navigator.pop(ctx);
              }
            },
            child: const Text('Start'),
          ),
        ],
      ),
    );
  }
}

// ─── Session Tile ─────────────────────────────────────────────────────────────

class _SessionTile extends StatelessWidget {
  const _SessionTile({required this.session, required this.ctrl});
  final StudySession session;
  final StudyController ctrl;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(session.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        color: AppColors.expense.withOpacity(0.12),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: AppColors.expense,
        ),
      ),
      confirmDismiss: (_) => showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Delete session?'),
          content: const Text('This cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.expense,
              ),
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
      onDismissed: (_) => ctrl.deleteSession(session.id),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.accentGlow,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Center(
                child: Text(
                  session.subject[0].toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.accentLight,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.subject,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${ctrl.formatDuration(session.duration)} · ${AppDateUtils.formatRelativeTime(session.date)}',
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                  if (session.notes != null && session.notes!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      session.notes!,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            Text(
              ctrl.formatDuration(session.duration),
              style: const TextStyle(
                color: AppColors.accentLight,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Empty State ──────────────────────────────────────────────────────────────

class _EmptySessions extends StatelessWidget {
  const _EmptySessions();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 32),
    child: Column(
      children: [
        Icon(
          Icons.timer_outlined,
          size: 52,
          color: AppColors.textMuted.withOpacity(0.5),
        ),
        const SizedBox(height: 16),
        const Text(
          'No study sessions yet',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Start the timer or add a session manually',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textMuted, fontSize: 13),
        ),
      ],
    ),
  );
}

// ─── Add Session Dialog ───────────────────────────────────────────────────────

void _showAddDialog(BuildContext context, StudyController ctrl) {
  final subjectCtrl = TextEditingController();
  final durationCtrl = TextEditingController();
  final notesCtrl = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
    ),
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Log study session',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: subjectCtrl,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: const InputDecoration(hintText: 'Subject'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: durationCtrl,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: const InputDecoration(hintText: 'Duration (minutes)'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: notesCtrl,
            maxLines: 2,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: const InputDecoration(hintText: 'Notes (optional)'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              final subject = subjectCtrl.text.trim();
              final duration = int.tryParse(durationCtrl.text.trim());
              if (subject.isEmpty || duration == null || duration <= 0) return;
              ctrl.addSession(
                subject,
                duration,
                notes: notesCtrl.text.trim().isNotEmpty
                    ? notesCtrl.text.trim()
                    : null,
              );
              Navigator.pop(ctx);
            },
            child: const Text('Save session'),
          ),
        ],
      ),
    ),
  );
}
