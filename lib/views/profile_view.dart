import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_theme.dart';
import '../controllers/auth_controller.dart';
import '../routes/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return Obx(() {
      if (!auth.isLoggedIn.value) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (Get.currentRoute == AppRoutes.profile) {
            Get.offNamed(AppRoutes.login);
          }
        });
        return const Scaffold(
          backgroundColor: AppColors.bg,
          body: Center(
            child: CircularProgressIndicator(color: AppColors.accentLight),
          ),
        );
      }

      return Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: Get.back,
          ),
          title: const Text('Profile'),
        ),
        body: _ProfileBody(auth: auth),
      );
    });
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody({required this.auth});
  final AuthController auth;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final name = (auth.user['name'] as String? ?? '').trim();
      final email = (auth.user['email'] as String? ?? '').trim();
      final id = (auth.user['id'] as String? ?? '').trim();
      final displayName = name.isNotEmpty ? name : 'Tracker';
      final initials = _initials(name, email);

      return ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          _ProfileHeader(
            initials: initials,
            displayName: displayName,
            email: email,
          ),
          const SizedBox(height: 28),
          const _SectionLabel('Account'),
          const SizedBox(height: 10),
          _InfoCard(
            children: [
              _InfoRow(
                icon: Icons.person_outline_rounded,
                label: 'Display name',
                value: displayName,
              ),
              const _InfoDivider(),
              _InfoRow(
                icon: Icons.mail_outline_rounded,
                label: 'Email',
                value: email.isNotEmpty ? email : '—',
              ),
              if (id.isNotEmpty) ...[
                const _InfoDivider(),
                _InfoRow(
                  icon: Icons.fingerprint_rounded,
                  label: 'User ID',
                  value: _shortId(id),
                  monospace: true,
                ),
              ],
            ],
          ),
          const SizedBox(height: 28),
          const _SectionLabel('Your trackers'),
          const SizedBox(height: 10),
          _InfoCard(
            children: [
              _TrackerRow(
                icon: Icons.account_balance_wallet_outlined,
                label: 'Expenses',
                color: AppColors.expense,
              ),
              const _InfoDivider(),
              _TrackerRow(
                icon: Icons.fitness_center_outlined,
                label: 'Workout',
                color: AppColors.info,
              ),
              const _InfoDivider(),
              _TrackerRow(
                icon: Icons.menu_book_outlined,
                label: 'Study',
                color: AppColors.income,
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _confirmLogout(auth),
              icon: const Icon(Icons.logout_rounded, size: 20),
              label: const Text('Sign out'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.expense,
                side: const BorderSide(color: AppColors.border),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  void _confirmLogout(AuthController auth) {
    Get.dialog(
      AlertDialog(
        title: const Text('Sign out?'),
        content: const Text(
          'You will need to sign in again to sync your data.',
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              await auth.logout();
              Get.offAllNamed(AppRoutes.main);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.expense),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.initials,
    required this.displayName,
    required this.email,
  });

  final String initials;
  final String displayName;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.accentGlow,
            border: Border.all(color: AppColors.accent, width: 2),
          ),
          alignment: Alignment.center,
          child: Text(
            initials,
            style: const TextStyle(
              color: AppColors.accentLight,
              fontSize: 32,
              fontWeight: FontWeight.w700,
              letterSpacing: -1,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          displayName,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.6,
          ),
        ),
        if (email.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            email,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 15,
            ),
          ),
        ],
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.accentGlow,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.verified_rounded, size: 14, color: AppColors.accentLight),
              SizedBox(width: 6),
              Text(
                'Signed in',
                style: TextStyle(
                  color: AppColors.accentLight,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        color: AppColors.textMuted,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.monospace = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool monospace;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textMuted),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    fontFamily: monospace ? 'monospace' : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TrackerRow extends StatelessWidget {
  const _TrackerRow({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 14),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textMuted,
            size: 20,
          ),
        ],
      ),
    );
  }
}

class _InfoDivider extends StatelessWidget {
  const _InfoDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, indent: 50, endIndent: 16);
  }
}

String _initials(String name, String email) {
  if (name.isNotEmpty) {
    final parts = name.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
    }
    return parts.first[0].toUpperCase();
  }
  if (email.isNotEmpty) return email[0].toUpperCase();
  return '?';
}

String _shortId(String id) {
  if (id.length <= 12) return id;
  return '${id.substring(0, 8)}…${id.substring(id.length - 4)}';
}
