import 'package:equatable/equatable.dart';
import '../../domain/entities/task.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

/// Start listening to tasks for the given user ID
class LoadTasks extends TaskEvent {
  final String userId;

  const LoadTasks(this.userId);

  @override
  List<Object?> get props => [userId];
}

/// Internal event fired when Firestore emits updated tasks list
class TasksUpdated extends TaskEvent {
  final List<TaskEntity> tasks;

  const TasksUpdated(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

/// Create a new task
class CreateTaskEvent extends TaskEvent {
  final String userId;
  final TaskEntity task;

  const CreateTaskEvent({required this.userId, required this.task});

  @override
  List<Object?> get props => [userId, task];
}

/// Update an existing task
class UpdateTaskEvent extends TaskEvent {
  final String userId;
  final TaskEntity task;

  const UpdateTaskEvent({required this.userId, required this.task});

  @override
  List<Object?> get props => [userId, task];
}

/// Delete a task
class DeleteTaskEvent extends TaskEvent {
  final String userId;
  final String taskId;

  const DeleteTaskEvent({required this.userId, required this.taskId});

  @override
  List<Object?> get props => [userId, taskId];
}

/// Toggle task isCompleted status
class ToggleTaskEvent extends TaskEvent {
  final String userId;
  final String taskId;
  final bool isCompleted;

  const ToggleTaskEvent({
    required this.userId,
    required this.taskId,
    required this.isCompleted,
  });

  @override
  List<Object?> get props => [userId, taskId, isCompleted];
}

/// Filter by priority ('All', 'Low', 'Medium', 'High') and status ('All', 'Completed', 'Incomplete')
class FilterTasksEvent extends TaskEvent {
  final String? priorityFilter;
  final String? statusFilter;

  const FilterTasksEvent({this.priorityFilter, this.statusFilter});

  @override
  List<Object?> get props => [priorityFilter, statusFilter];
}

/// Case-insensitive search on title and description
class SearchTasksEvent extends TaskEvent {
  final String query;

  const SearchTasksEvent(this.query);

  @override
  List<Object?> get props => [query];
}

/// Clear all active filters and search queries
class ClearFiltersEvent extends TaskEvent {}
