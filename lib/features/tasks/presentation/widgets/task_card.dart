import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/task.dart';
import 'priority_chip.dart';

class TaskCard extends StatelessWidget {
  final TaskEntity task;
  final ValueChanged<bool?> onToggle;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = task.isCompleted;

    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.space12),
      decoration: BoxDecoration(
        color: isCompleted ? AppColors.completedCard : AppColors.cardSurface,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(
          color: isCompleted
              ? AppColors.border.withValues(alpha: 0.6)
              : AppColors.border,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isCompleted ? 0.01 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.space16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Checkbox, Title, Popup Menu
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Custom Checkbox
                    GestureDetector(
                      onTap: () => onToggle(!isCompleted),
                      child: Container(
                        width: 24,
                        height: 24,
                        margin: const EdgeInsets.only(top: 2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCompleted
                              ? AppColors.primary
                              : Colors.transparent,
                          border: Border.all(
                            color: isCompleted
                                ? AppColors.primary
                                : AppColors.textMuted,
                            width: 2,
                          ),
                        ),
                        child: isCompleted
                            ? const Icon(
                                Icons.check_rounded,
                                size: 16,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: AppConstants.space12),
                    // Title
                    Expanded(
                      child: Text(
                        task.title,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  decoration: isCompleted
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  color: isCompleted
                                      ? AppColors.textMuted
                                      : AppColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ),
                    // Actions Menu
                    PopupMenuButton<String>(
                      icon: const Icon(
                        Icons.more_vert_rounded,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onSelected: (value) {
                        if (value == 'edit') {
                          onEdit();
                        } else if (value == 'delete') {
                          onDelete();
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit_outlined,
                                  size: 18, color: AppColors.textPrimary),
                              SizedBox(width: AppConstants.space8),
                              Text(AppStrings.editTask),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete_outline_rounded,
                                  size: 18, color: AppColors.error),
                              SizedBox(width: AppConstants.space8),
                              Text(
                                AppStrings.deleteTask,
                                style: TextStyle(color: AppColors.error),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Description preview if available
                if (task.description.trim().isNotEmpty) ...[
                  const SizedBox(height: AppConstants.space8),
                  Padding(
                    padding: const EdgeInsets.only(left: 36.0),
                    child: Text(
                      task.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isCompleted
                                ? AppColors.textMuted
                                : AppColors.textSecondary,
                            height: 1.3,
                          ),
                    ),
                  ),
                ],
                const SizedBox(height: AppConstants.space12),
                // Bottom Metadata Row: Due Date + Priority Chip
                Padding(
                  padding: const EdgeInsets.only(left: 36.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: isCompleted
                            ? AppColors.textMuted
                            : AppColors.primary,
                      ),
                      const SizedBox(width: AppConstants.space4),
                      Text(
                        DateFormatter.formatDueDate(task.dueDate),
                        style: TextStyle(
                          color: isCompleted
                              ? AppColors.textMuted
                              : AppColors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      PriorityChip(priority: task.priority),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
