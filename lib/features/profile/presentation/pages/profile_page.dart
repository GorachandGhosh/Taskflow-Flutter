import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../tasks/domain/entities/task.dart';
import '../../../tasks/presentation/bloc/task_bloc.dart';
import '../../../tasks/presentation/bloc/task_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        ),
        title: const Text('Confirm Logout',
            style: TextStyle(fontWeight: FontWeight.w700)),
        content: const Text(
          'Are you sure you want to log out of TaskFlow?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              context.read<AuthBloc>().add(LogoutRequested());
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
              ),
            ),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  void _sendPasswordReset(BuildContext context, String email) {
    context.read<AuthBloc>().add(PasswordResetRequested(email));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Password reset instructions sent to $email.'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        UserEntity? user;
        if (authState is AuthAuthenticated) {
          user = authState.user;
        }

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  size: 20, color: AppColors.textPrimary),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text(
              'Worker Profile',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                fontSize: 18,
              ),
            ),
            centerTitle: true,
          ),
          body: BlocBuilder<TaskBloc, TaskState>(
            builder: (context, taskState) {
              List<TaskEntity> allTasks = [];
              allTasks = taskState.allTasks;

              final total = allTasks.length;
              final completed = allTasks.where((t) => t.isCompleted).length;
              final pending = total - completed;
              final completionRate =
                  total > 0 ? ((completed / total) * 100).round() : 0;

              final highPriorityCount = allTasks
                  .where(
                      (t) => t.priority == TaskPriority.high && !t.isCompleted)
                  .length;

              final userEmail = user?.email ?? 'gig.worker@taskflow.app';
              final userInitial =
                  userEmail.isNotEmpty ? userEmail[0].toUpperCase() : 'W';

              return SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.space20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Profile Header Card
                    Container(
                      padding: const EdgeInsets.all(AppConstants.space20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusLarge),
                        border: Border.all(color: AppColors.border),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 34,
                            backgroundColor: AppColors.primaryLight,
                            child: Text(
                              userInitial,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppConstants.space16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userEmail.split('@').first,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  userEmail,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'Verified Gig Worker',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppConstants.space20),

                    // Productivity Stats Overview
                    const Text(
                      'Productivity & Performance',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppConstants.space12),

                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricCard(
                            title: 'Completion',
                            value: '$completionRate%',
                            subtitle: '$completed of $total done',
                            icon: Icons.pie_chart_rounded,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: AppConstants.space12),
                        Expanded(
                          child: _buildMetricCard(
                            title: 'High Priority',
                            value: '$highPriorityCount',
                            subtitle: 'Pending urgent',
                            icon: Icons.priority_high_rounded,
                            color: AppColors.error,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.space12),

                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricCard(
                            title: 'Total Tasks',
                            value: '$total',
                            subtitle: 'Lifetime gig tasks',
                            icon: Icons.assignment_outlined,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: AppConstants.space12),
                        Expanded(
                          child: _buildMetricCard(
                            title: 'Incomplete',
                            value: '$pending',
                            subtitle: 'Remaining items',
                            icon: Icons.pending_actions_rounded,
                            color: AppColors.warning,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.space24),

                    // Productivity Bar
                    Container(
                      padding: const EdgeInsets.all(AppConstants.space16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusMedium),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Overall Completion Rate',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '$completionRate%',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: total > 0 ? (completed / total) : 0,
                              minHeight: 8,
                              backgroundColor: AppColors.border,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppConstants.space24),

                    // Account Actions
                    const Text(
                      'Account & Security',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppConstants.space12),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusMedium),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.offline_pin_outlined,
                                color: AppColors.success),
                            title: const Text('Offline Local Cache',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600)),
                            subtitle: const Text(
                                'Tasks cached locally via SharedPreferences',
                                style: TextStyle(fontSize: 12)),
                            trailing: const Icon(Icons.check_circle_rounded,
                                color: AppColors.success, size: 20),
                          ),
                          const Divider(height: 1, color: AppColors.border),
                          ListTile(
                            leading: const Icon(Icons.lock_reset_rounded,
                                color: AppColors.primary),
                            title: const Text('Reset Password',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600)),
                            subtitle: const Text(
                                'Send password reset email to your inbox',
                                style: TextStyle(fontSize: 12)),
                            trailing: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 14),
                            onTap: () => _sendPasswordReset(context, userEmail),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppConstants.space24),

                    // Log Out Button
                    AppButton(
                      text: 'Log Out',
                      backgroundColor: Colors.white,
                      textColor: AppColors.error,
                      isOutlined: true,
                      icon: const Icon(Icons.logout_rounded),
                      onPressed: () => _showLogoutDialog(context),
                    ),
                    const SizedBox(height: AppConstants.space32),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.space16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              Icon(icon, color: color, size: 18),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
