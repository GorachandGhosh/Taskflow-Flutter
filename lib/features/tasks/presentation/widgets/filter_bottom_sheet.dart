import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_button.dart';
import '../bloc/task_state.dart';

class FilterBottomSheet extends StatefulWidget {
  final TaskPriorityFilter currentPriority;
  final TaskStatusFilter currentStatus;
  final Function(TaskPriorityFilter priority, TaskStatusFilter status) onApply;

  const FilterBottomSheet({
    super.key,
    required this.currentPriority,
    required this.currentStatus,
    required this.onApply,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late TaskPriorityFilter _selectedPriority;
  late TaskStatusFilter _selectedStatus;

  @override
  void initState() {
    super.initState();
    _selectedPriority = widget.currentPriority;
    _selectedStatus = widget.currentStatus;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.space24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.filterSheetTitle,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedPriority = TaskPriorityFilter.all;
                      _selectedStatus = TaskStatusFilter.all;
                    });
                  },
                  child: const Text(
                    AppStrings.resetFilters,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.space16),
            // Priority Filter Section
            Text(
              AppStrings.filterByPriority,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: AppConstants.space8),
            Wrap(
              spacing: AppConstants.space8,
              children: [
                _buildChoiceChip('All', _selectedPriority == TaskPriorityFilter.all, () {
                  setState(() => _selectedPriority = TaskPriorityFilter.all);
                }),
                _buildChoiceChip('Low', _selectedPriority == TaskPriorityFilter.low, () {
                  setState(() => _selectedPriority = TaskPriorityFilter.low);
                }),
                _buildChoiceChip('Medium', _selectedPriority == TaskPriorityFilter.medium, () {
                  setState(() => _selectedPriority = TaskPriorityFilter.medium);
                }),
                _buildChoiceChip('High', _selectedPriority == TaskPriorityFilter.high, () {
                  setState(() => _selectedPriority = TaskPriorityFilter.high);
                }),
              ],
            ),
            const SizedBox(height: AppConstants.space24),
            // Status Filter Section
            Text(
              AppStrings.filterByStatus,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: AppConstants.space8),
            Wrap(
              spacing: AppConstants.space8,
              children: [
                _buildChoiceChip('All', _selectedStatus == TaskStatusFilter.all, () {
                  setState(() => _selectedStatus = TaskStatusFilter.all);
                }),
                _buildChoiceChip('Completed', _selectedStatus == TaskStatusFilter.completed, () {
                  setState(() => _selectedStatus = TaskStatusFilter.completed);
                }),
                _buildChoiceChip('Incomplete', _selectedStatus == TaskStatusFilter.incomplete, () {
                  setState(() => _selectedStatus = TaskStatusFilter.incomplete);
                }),
              ],
            ),
            const SizedBox(height: AppConstants.space32),
            // Apply Button
            AppButton(
              text: AppStrings.applyFilters,
              onPressed: () {
                widget.onApply(_selectedPriority, _selectedStatus);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChoiceChip(String label, bool isSelected, VoidCallback onTap) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.primaryContainer,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        fontSize: 13,
      ),
      side: BorderSide(
        color: isSelected ? AppColors.primary : AppColors.border,
        width: 1.2,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
      ),
    );
  }
}
