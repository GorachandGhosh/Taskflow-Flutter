import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../domain/entities/task.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import '../widgets/priority_chip.dart';

class EditTaskPage extends StatefulWidget {
  final TaskEntity task;

  const EditTaskPage({super.key, required this.task});

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _dueDate;
  late TaskPriority _priority;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description);
    _dueDate = widget.task.dueDate;
    _priority = widget.task.priority;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  void _onUpdateTask() {
    if (_formKey.currentState?.validate() ?? false) {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthAuthenticated) {
        final updatedTask = widget.task.copyWith(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          dueDate: _dueDate,
          priority: _priority,
          updatedAt: DateTime.now(),
        );

        context.read<TaskBloc>().add(
              UpdateTaskEvent(userId: authState.user.id, task: updatedTask),
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskBloc, TaskState>(
      listener: (context, state) {
        if (state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage!),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.of(context).pop();
        } else if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        final isSubmitting = state.isSubmitting;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text('Edit Task'),
          ),
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(AppConstants.space24),
                children: [
                  AppTextField(
                    label: AppStrings.titleLabel,
                    hint: AppStrings.titleHint,
                    controller: _titleController,
                    validator: Validators.validateTitle,
                  ),
                  const SizedBox(height: AppConstants.space20),
                  AppTextField(
                    label: AppStrings.descriptionLabel,
                    hint: AppStrings.descriptionHint,
                    controller: _descriptionController,
                    maxLines: 4,
                    validator: Validators.validateDescription,
                  ),
                  const SizedBox(height: AppConstants.space24),
                  // Due Date
                  Text(
                    AppStrings.dueDateLabel,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: AppConstants.space8),
                  InkWell(
                    onTap: () => _selectDueDate(context),
                    borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.space16,
                        vertical: AppConstants.space16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                        border: Border.all(color: AppColors.border, width: 1.2),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 18,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: AppConstants.space12),
                          Text(
                            DateFormatter.formatDate(_dueDate),
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppConstants.space24),
                  // Priority
                  Text(
                    AppStrings.priorityLabel,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: AppConstants.space12),
                  Row(
                    children: [
                      PriorityChip(
                        priority: TaskPriority.low,
                        isSelected: _priority == TaskPriority.low,
                        onTap: () => setState(() => _priority = TaskPriority.low),
                      ),
                      const SizedBox(width: AppConstants.space8),
                      PriorityChip(
                        priority: TaskPriority.medium,
                        isSelected: _priority == TaskPriority.medium,
                        onTap: () => setState(() => _priority = TaskPriority.medium),
                      ),
                      const SizedBox(width: AppConstants.space8),
                      PriorityChip(
                        priority: TaskPriority.high,
                        isSelected: _priority == TaskPriority.high,
                        onTap: () => setState(() => _priority = TaskPriority.high),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.space40),
                  AppButton(
                    text: AppStrings.saveChanges,
                    isLoading: isSubmitting,
                    onPressed: _onUpdateTask,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
