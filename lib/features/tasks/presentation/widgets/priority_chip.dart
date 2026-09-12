import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/task.dart';

class PriorityChip extends StatelessWidget {
  final TaskPriority priority;
  final bool isSelected;
  final VoidCallback? onTap;

  const PriorityChip({
    super.key,
    required this.priority,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (priority) {
      case TaskPriority.high:
        bg = AppColors.priorityHighBg;
        fg = AppColors.priorityHigh;
        break;
      case TaskPriority.medium:
        bg = AppColors.priorityMediumBg;
        fg = AppColors.priorityMedium;
        break;
      case TaskPriority.low:
        bg = AppColors.priorityLowBg;
        fg = AppColors.priorityLow;
        break;
    }

    final chip = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.space12,
        vertical: AppConstants.space4 + 2,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
        border: isSelected ? Border.all(color: fg, width: 1.8) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: fg,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppConstants.space8),
          Text(
            priority.label.toUpperCase(),
            style: TextStyle(
              color: fg,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
        child: chip,
      );
    }

    return chip;
  }
}
