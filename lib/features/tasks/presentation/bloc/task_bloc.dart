import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/task.dart';
import '../../domain/usecases/create_task.dart';
import '../../domain/usecases/delete_task.dart';
import '../../domain/usecases/get_tasks.dart';
import '../../domain/usecases/toggle_task.dart';
import '../../domain/usecases/update_task.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasks getTasks;
  final CreateTask createTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;
  final ToggleTask toggleTask;

  StreamSubscription? _tasksSubscription;

  TaskBloc({
    required this.getTasks,
    required this.createTask,
    required this.updateTask,
    required this.deleteTask,
    required this.toggleTask,
  }) : super(const TaskState(isLoading: true)) {
    on<LoadTasks>(_onLoadTasks);
    on<TasksUpdated>(_onTasksUpdated);
    on<CreateTaskEvent>(_onCreateTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<ToggleTaskEvent>(_onToggleTask);
    on<FilterTasksEvent>(_onFilterTasks);
    on<SearchTasksEvent>(_onSearchTasks);
    on<ClearFiltersEvent>(_onClearFilters);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    await _tasksSubscription?.cancel();

    _tasksSubscription = getTasks(event.userId).listen(
      (tasks) {
        add(TasksUpdated(tasks));
      },
      onError: (error) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: error is Failure ? error.message : error.toString(),
        ));
      },
    );
  }

  void _onTasksUpdated(TasksUpdated event, Emitter<TaskState> emit) {
    // Sort tasks ascending by due date (and secondary createdAt)
    final sortedTasks = List<TaskEntity>.from(event.tasks)..sort((a, b) {
      final dueComp = a.dueDate.compareTo(b.dueDate);
      if (dueComp != 0) return dueComp;
      return a.createdAt.compareTo(b.createdAt);
    });

    final filtered = _applyFiltersAndSearch(
      tasks: sortedTasks,
      priorityFilter: state.priorityFilter,
      statusFilter: state.statusFilter,
      query: state.searchQuery,
    );

    emit(state.copyWith(
      isLoading: false,
      allTasks: sortedTasks,
      filteredTasks: filtered,
    ));
  }

  Future<void> _onCreateTask(CreateTaskEvent event, Emitter<TaskState> emit) async {
    emit(state.copyWith(isSubmitting: true, clearError: true, clearSuccess: true));
    try {
      await createTask(event.userId, event.task);
      emit(state.copyWith(
        isSubmitting: false,
        successMessage: 'Task created successfully!',
      ));
    } on Failure catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: 'Failed to create task.'));
    }
  }

  Future<void> _onUpdateTask(UpdateTaskEvent event, Emitter<TaskState> emit) async {
    emit(state.copyWith(isSubmitting: true, clearError: true, clearSuccess: true));
    try {
      await updateTask(event.userId, event.task);
      emit(state.copyWith(
        isSubmitting: false,
        successMessage: 'Task updated successfully!',
      ));
    } on Failure catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: 'Failed to update task.'));
    }
  }

  Future<void> _onDeleteTask(DeleteTaskEvent event, Emitter<TaskState> emit) async {
    try {
      await deleteTask(event.userId, event.taskId);
      emit(state.copyWith(successMessage: 'Task deleted.'));
    } on Failure catch (e) {
      emit(state.copyWith(errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to delete task.'));
    }
  }

  Future<void> _onToggleTask(ToggleTaskEvent event, Emitter<TaskState> emit) async {
    try {
      await toggleTask(event.userId, event.taskId, event.isCompleted);
    } on Failure catch (e) {
      emit(state.copyWith(errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to toggle task.'));
    }
  }

  void _onFilterTasks(FilterTasksEvent event, Emitter<TaskState> emit) {
    TaskPriorityFilter newPriority = state.priorityFilter;
    TaskStatusFilter newStatus = state.statusFilter;

    if (event.priorityFilter != null) {
      switch (event.priorityFilter!.toLowerCase()) {
        case 'low':
          newPriority = TaskPriorityFilter.low;
          break;
        case 'medium':
          newPriority = TaskPriorityFilter.medium;
          break;
        case 'high':
          newPriority = TaskPriorityFilter.high;
          break;
        default:
          newPriority = TaskPriorityFilter.all;
      }
    }

    if (event.statusFilter != null) {
      switch (event.statusFilter!.toLowerCase()) {
        case 'completed':
          newStatus = TaskStatusFilter.completed;
          break;
        case 'incomplete':
        case 'pending':
          newStatus = TaskStatusFilter.incomplete;
          break;
        default:
          newStatus = TaskStatusFilter.all;
      }
    }

    final filtered = _applyFiltersAndSearch(
      tasks: state.allTasks,
      priorityFilter: newPriority,
      statusFilter: newStatus,
      query: state.searchQuery,
    );

    emit(state.copyWith(
      priorityFilter: newPriority,
      statusFilter: newStatus,
      filteredTasks: filtered,
    ));
  }

  void _onSearchTasks(SearchTasksEvent event, Emitter<TaskState> emit) {
    final filtered = _applyFiltersAndSearch(
      tasks: state.allTasks,
      priorityFilter: state.priorityFilter,
      statusFilter: state.statusFilter,
      query: event.query,
    );

    emit(state.copyWith(
      searchQuery: event.query,
      filteredTasks: filtered,
    ));
  }

  void _onClearFilters(ClearFiltersEvent event, Emitter<TaskState> emit) {
    final filtered = _applyFiltersAndSearch(
      tasks: state.allTasks,
      priorityFilter: TaskPriorityFilter.all,
      statusFilter: TaskStatusFilter.all,
      query: '',
    );

    emit(state.copyWith(
      priorityFilter: TaskPriorityFilter.all,
      statusFilter: TaskStatusFilter.all,
      searchQuery: '',
      filteredTasks: filtered,
    ));
  }

  List<TaskEntity> _applyFiltersAndSearch({
    required List<TaskEntity> tasks,
    required TaskPriorityFilter priorityFilter,
    required TaskStatusFilter statusFilter,
    required String query,
  }) {
    return tasks.where((task) {
      // 1. Priority filter
      if (priorityFilter != TaskPriorityFilter.all) {
        if (priorityFilter == TaskPriorityFilter.low && task.priority != TaskPriority.low) {
          return false;
        }
        if (priorityFilter == TaskPriorityFilter.medium && task.priority != TaskPriority.medium) {
          return false;
        }
        if (priorityFilter == TaskPriorityFilter.high && task.priority != TaskPriority.high) {
          return false;
        }
      }

      // 2. Status filter
      if (statusFilter == TaskStatusFilter.completed && !task.isCompleted) {
        return false;
      }
      if (statusFilter == TaskStatusFilter.incomplete && task.isCompleted) {
        return false;
      }

      // 3. Search query (case-insensitive on title and description)
      if (query.trim().isNotEmpty) {
        final q = query.trim().toLowerCase();
        final titleMatch = task.title.toLowerCase().contains(q);
        final descMatch = task.description.toLowerCase().contains(q);
        if (!titleMatch && !descMatch) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  @override
  Future<void> close() {
    _tasksSubscription?.cancel();
    return super.close();
  }
}
