import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_button.dart';

class EmptyTaskView extends StatelessWidget {
  final bool isSearchOrFilter;
  final VoidCallback? onCreateTask;
  final VoidCallback? onResetFilters;

  const EmptyTaskView({
    super.key,
    this.isSearchOrFilter = false,
    this.onCreateTask,
    this.onResetFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.space32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer..withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSearchOrFilter
                    ? Icons.search_off_rounded
                    : Icons.task_alt_rounded,
                color: AppColors.primary,
                size: 40,
              ),
            ),
            const SizedBox(height: AppConstants.space20),
            Text(
              isSearchOrFilter
                  ? AppStrings.emptySearchTitle
                  : AppStrings.emptyTasksTitle,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.space8),
            Text(
              isSearchOrFilter
                  ? AppStrings.emptySearchSubtitle
                  : AppStrings.emptyTasksSubtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.space24),
            if (!isSearchOrFilter && onCreateTask != null)
              SizedBox(
                width: 170,
                child: AppButton(
                  text: AppStrings.createTask,
                  icon: const Icon(Icons.add_rounded,
                      size: 20, color: Colors.white),
                  onPressed: onCreateTask,
                ),
              )
            else if (isSearchOrFilter && onResetFilters != null)
              SizedBox(
                width: 170,
                child: AppButton(
                  text: AppStrings.resetFilters,
                  isOutlined: true,
                  onPressed: onResetFilters,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
