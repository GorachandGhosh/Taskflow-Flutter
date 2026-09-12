import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../domain/entities/task.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import '../widgets/empty_task_view.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/task_card.dart';
import '../widgets/task_detail_sheet.dart';
import 'add_task_page.dart';
import 'edit_task_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load tasks for currently authenticated user
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthAuthenticated) {
        context.read<TaskBloc>().add(LoadTasks(authState.user.id));
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return AppStrings.greetingMorning;
    } else if (hour < 17) {
      return AppStrings.greetingAfternoon;
    } else {
      return AppStrings.greetingEvening;
    }
  }

  void _showFilterSheet(BuildContext context, TaskState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => FilterBottomSheet(
        currentPriority: state.priorityFilter,
        currentStatus: state.statusFilter,
        onApply: (priority, status) {
          context.read<TaskBloc>().add(
                FilterTasksEvent(
                  priorityFilter: priority.name,
                  statusFilter: status.name,
                ),
              );
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, TaskEntity task) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(AppStrings.deleteConfirmationTitle),
        content: const Text(AppStrings.deleteConfirmationMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              final authState = context.read<AuthBloc>().state;
              if (authState is AuthAuthenticated) {
                context.read<TaskBloc>().add(
                      DeleteTaskEvent(userId: authState.user.id, taskId: task.id),
                    );
              }
            },
            child: const Text(
              AppStrings.delete,
              style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showTaskDetail(BuildContext context, TaskEntity task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => TaskDetailSheet(
        task: task,
        onToggle: () {
          final authState = context.read<AuthBloc>().state;
          if (authState is AuthAuthenticated) {
            context.read<TaskBloc>().add(
                  ToggleTaskEvent(
                    userId: authState.user.id,
                    taskId: task.id,
                    isCompleted: !task.isCompleted,
                  ),
                );
          }
        },
        onEdit: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => EditTaskPage(task: task)),
          );
        },
        onDelete: () => _showDeleteDialog(context, task),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        }
      },
      child: BlocConsumer<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
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
          final authState = context.watch<AuthBloc>().state;
          final userEmail = authState is AuthAuthenticated ? authState.user.email : '';

          return Scaffold(
            backgroundColor: AppColors.scaffoldBackground,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getGreeting(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    userEmail.isNotEmpty ? userEmail : AppStrings.homeSubtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.account_circle_outlined, color: AppColors.primary, size: 26),
                  tooltip: 'Worker Profile & Stats',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ProfilePage()),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.logout_rounded, color: AppColors.textSecondary),
                  tooltip: 'Log out',
                  onPressed: () {
                    context.read<AuthBloc>().add(LogoutRequested());
                  },
                ),
                const SizedBox(width: AppConstants.space8),
              ],
            ),
            body: SafeArea(
              child: Column(
                children: [
                  // Search and Filter Bar inspired by Reference 2
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.space16,
                      vertical: AppConstants.space8,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (query) {
                              context.read<TaskBloc>().add(SearchTasksEvent(query));
                            },
                            decoration: InputDecoration(
                              hintText: AppStrings.searchHint,
                              prefixIcon: const Icon(
                                Icons.search_rounded,
                                color: AppColors.textSecondary,
                                size: 20,
                              ),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear_rounded, size: 18),
                                      onPressed: () {
                                        _searchController.clear();
                                        context.read<TaskBloc>().add(const SearchTasksEvent(''));
                                      },
                                    )
                                  : null,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: AppConstants.space16,
                                vertical: AppConstants.space12,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppConstants.space8),
                        // Filter Button
                        Container(
                          decoration: BoxDecoration(
                            color: (state.priorityFilter != TaskPriorityFilter.all ||
                                    state.statusFilter != TaskStatusFilter.all)
                                ? AppColors.primary
                                : Colors.white,
                            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                            border: Border.all(
                              color: (state.priorityFilter != TaskPriorityFilter.all ||
                                      state.statusFilter != TaskStatusFilter.all)
                                  ? AppColors.primary
                                  : AppColors.border,
                            ),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.tune_rounded,
                              color: (state.priorityFilter != TaskPriorityFilter.all ||
                                      state.statusFilter != TaskStatusFilter.all)
                                  ? Colors.white
                                  : AppColors.textPrimary,
                              size: 20,
                            ),
                            onPressed: () => _showFilterSheet(context, state),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Task Statistics Summary Cards
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.space16,
                      vertical: AppConstants.space8,
                    ),
                    child: Row(
                      children: [
                        _buildStatCard(
                          title: AppStrings.totalTasks,
                          count: state.totalCount,
                          color: AppColors.primary,
                          bg: AppColors.primaryContainer,
                        ),
                        const SizedBox(width: AppConstants.space8),
                        _buildStatCard(
                          title: AppStrings.pendingTasks,
                          count: state.pendingCount,
                          color: AppColors.priorityMedium,
                          bg: AppColors.priorityMediumBg,
                        ),
                        const SizedBox(width: AppConstants.space8),
                        _buildStatCard(
                          title: AppStrings.completedTasks,
                          count: state.completedCount,
                          color: AppColors.priorityLow,
                          bg: AppColors.priorityLowBg,
                        ),
                      ],
                    ),
                  ),

                  // Quick Status Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.space16,
                      vertical: AppConstants.space8,
                    ),
                    child: Row(
                      children: [
                        _buildFilterPill(
                          label: AppStrings.filterAll,
                          isSelected: state.statusFilter == TaskStatusFilter.all,
                          onTap: () {
                            context.read<TaskBloc>().add(
                                  const FilterTasksEvent(statusFilter: 'all'),
                                );
                          },
                        ),
                        const SizedBox(width: AppConstants.space8),
                        _buildFilterPill(
                          label: AppStrings.filterPending,
                          isSelected: state.statusFilter == TaskStatusFilter.incomplete,
                          onTap: () {
                            context.read<TaskBloc>().add(
                                  const FilterTasksEvent(statusFilter: 'incomplete'),
                                );
                          },
                        ),
                        const SizedBox(width: AppConstants.space8),
                        _buildFilterPill(
                          label: AppStrings.filterCompleted,
                          isSelected: state.statusFilter == TaskStatusFilter.completed,
                          onTap: () {
                            context.read<TaskBloc>().add(
                                  const FilterTasksEvent(statusFilter: 'completed'),
                                );
                          },
                        ),
                        if (state.priorityFilter != TaskPriorityFilter.all) ...[
                          const SizedBox(width: AppConstants.space8),
                          Chip(
                            label: Text(
                              'Priority: ${state.priorityFilter.name.toUpperCase()}',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            deleteIcon: const Icon(Icons.close, size: 16),
                            onDeleted: () {
                              context.read<TaskBloc>().add(
                                    const FilterTasksEvent(priorityFilter: 'all'),
                                  );
                            },
                            backgroundColor: AppColors.primaryContainer,
                            labelStyle: const TextStyle(color: AppColors.primary),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Tasks List Body
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        if (state.isLoading) {
                          return const LoadingWidget(message: 'Loading tasks...');
                        }

                        if (state.errorMessage != null && state.allTasks.isEmpty) {
                          return AppErrorWidget(
                            message: state.errorMessage!,
                            onRetry: () {
                              if (authState is AuthAuthenticated) {
                                context.read<TaskBloc>().add(LoadTasks(authState.user.id));
                              }
                            },
                          );
                        }

                        if (state.allTasks.isEmpty) {
                          return EmptyTaskView(
                            isSearchOrFilter: false,
                            onCreateTask: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const AddTaskPage()),
                              );
                            },
                          );
                        }

                        if (state.filteredTasks.isEmpty) {
                          return EmptyTaskView(
                            isSearchOrFilter: true,
                            onResetFilters: () {
                              _searchController.clear();
                              context.read<TaskBloc>().add(ClearFiltersEvent());
                            },
                          );
                        }

                        // Group tasks by category
                        final groupedTasks = <String, List<TaskEntity>>{};
                        for (final task in state.filteredTasks) {
                          final category = DateFormatter.getDateGroupCategory(task.dueDate);
                          groupedTasks.putIfAbsent(category, () => []).add(task);
                        }

                        final categories = groupedTasks.keys.toList();

                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.space16,
                            vertical: AppConstants.space8,
                          ),
                          itemCount: categories.length,
                          itemBuilder: (context, catIndex) {
                            final category = categories[catIndex];
                            final tasksInCategory = groupedTasks[category]!;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: AppConstants.space8,
                                    horizontal: AppConstants.space4,
                                  ),
                                  child: Text(
                                    category,
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ),
                                ...tasksInCategory.map((task) {
                                  return TaskCard(
                                    task: task,
                                    onTap: () => _showTaskDetail(context, task),
                                    onToggle: (val) {
                                      if (authState is AuthAuthenticated) {
                                        context.read<TaskBloc>().add(
                                              ToggleTaskEvent(
                                                userId: authState.user.id,
                                                taskId: task.id,
                                                isCompleted: val ?? false,
                                              ),
                                            );
                                      }
                                    },
                                    onEdit: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => EditTaskPage(task: task),
                                        ),
                                      );
                                    },
                                    onDelete: () => _showDeleteDialog(context, task),
                                  );
                                }),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AddTaskPage()),
                );
              },
              child: const Icon(Icons.add_rounded, size: 28),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required int count,
    required Color color,
    required Color bg,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.space12,
          vertical: AppConstants.space12,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPill({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.radiusFull),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.space16,
          vertical: AppConstants.space8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusFull),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: 1.2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
