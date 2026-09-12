import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/app_button.dart';
import '../../domain/entities/task.dart';
import 'priority_chip.dart';

class TaskDetailSheet extends StatelessWidget {
  final TaskEntity task;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TaskDetailSheet({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.space24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Priority + Status Pill + Close button
            Row(
              children: [
                PriorityChip(priority: task.priority),
                const SizedBox(width: AppConstants.space8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.space12,
                    vertical: AppConstants.space4 + 2,
                  ),
                  decoration: BoxDecoration(
                    color: task.isCompleted
                        ? AppColors.priorityLowBg
                        : AppColors.secondaryContainer,
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusFull),
                  ),
                  child: Text(
                    task.isCompleted ? 'COMPLETED' : 'PENDING',
                    style: TextStyle(
                      color: task.isCompleted
                          ? AppColors.priorityLow
                          : AppColors.secondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.space16),
            // Title
            Text(
              task.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    decoration:
                        task.isCompleted ? TextDecoration.lineThrough : null,
                    color: task.isCompleted
                        ? AppColors.textMuted
                        : AppColors.textPrimary,
                  ),
            ),
            if (task.description.trim().isNotEmpty) ...[
              const SizedBox(height: AppConstants.space12),
              Text(
                task.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
              ),
            ],
            const SizedBox(height: AppConstants.space24),
            const Divider(color: AppColors.border),
            const SizedBox(height: AppConstants.space16),
            // Dates Section
            _buildInfoRow(
              icon: Icons.calendar_today_outlined,
              label: 'Due Date',
              value: DateFormatter.formatDate(task.dueDate),
            ),
            const SizedBox(height: AppConstants.space8),
            _buildInfoRow(
              icon: Icons.access_time_rounded,
              label: 'Created',
              value: DateFormatter.formatDateTime(task.createdAt),
            ),
            const SizedBox(height: AppConstants.space8),
            _buildInfoRow(
              icon: Icons.update_rounded,
              label: 'Updated',
              value: DateFormatter.formatDateTime(task.updatedAt),
            ),
            const SizedBox(height: AppConstants.space24),
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: task.isCompleted
                        ? AppStrings.markIncomplete
                        : AppStrings.markComplete,
                    icon: Icon(
                      task.isCompleted
                          ? Icons.remove_done_rounded
                          : Icons.check_circle_outline_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      onToggle();
                    },
                  ),
                ),
                const SizedBox(width: AppConstants.space12),
                IconButton.outlined(
                  style: IconButton.styleFrom(
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusMedium),
                    ),
                  ),
                  icon: const Icon(Icons.edit_outlined,
                      color: AppColors.textPrimary),
                  onPressed: () {
                    Navigator.of(context).pop();
                    onEdit();
                  },
                ),
                const SizedBox(width: AppConstants.space8),
                IconButton.outlined(
                  style: IconButton.styleFrom(
                    side: const BorderSide(color: AppColors.priorityHighBg),
                    backgroundColor:
                        AppColors.priorityHighBg.withValues(alpha: 0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusMedium),
                    ),
                  ),
                  icon: const Icon(Icons.delete_outline_rounded,
                      color: AppColors.error),
                  onPressed: () {
                    Navigator.of(context).pop();
                    onDelete();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: AppConstants.space8),
        Text(
          '$label: ',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
