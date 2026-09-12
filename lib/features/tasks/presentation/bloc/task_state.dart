import 'package:equatable/equatable.dart';
import '../../domain/entities/task.dart';

enum TaskStatusFilter { all, completed, incomplete }
enum TaskPriorityFilter { all, low, medium, high }

class TaskState extends Equatable {
  final bool isLoading;
  final bool isSubmitting;
  final List<TaskEntity> allTasks;
  final List<TaskEntity> filteredTasks;
  final TaskPriorityFilter priorityFilter;
  final TaskStatusFilter statusFilter;
  final String searchQuery;
  final String? errorMessage;
  final String? successMessage;

  const TaskState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.allTasks = const [],
    this.filteredTasks = const [],
    this.priorityFilter = TaskPriorityFilter.all,
    this.statusFilter = TaskStatusFilter.all,
    this.searchQuery = '',
    this.errorMessage,
    this.successMessage,
  });

  // Statistics
  int get totalCount => allTasks.length;
  int get completedCount => allTasks.where((t) => t.isCompleted).length;
  int get pendingCount => allTasks.where((t) => !t.isCompleted).length;

  TaskState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    List<TaskEntity>? allTasks,
    List<TaskEntity>? filteredTasks,
    TaskPriorityFilter? priorityFilter,
    TaskStatusFilter? statusFilter,
    String? searchQuery,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return TaskState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      allTasks: allTasks ?? this.allTasks,
      filteredTasks: filteredTasks ?? this.filteredTasks,
      priorityFilter: priorityFilter ?? this.priorityFilter,
      statusFilter: statusFilter ?? this.statusFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isSubmitting,
        allTasks,
        filteredTasks,
        priorityFilter,
        statusFilter,
        searchQuery,
        errorMessage,
        successMessage,
      ];
}
