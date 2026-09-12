import '../../domain/entities/task.dart';

/// Abstract contract for task management repository in the domain layer.
abstract class TaskRepository {
  Stream<List<TaskEntity>> getTasks(String userId);
  Future<void> createTask(String userId, TaskEntity task);
  Future<void> updateTask(String userId, TaskEntity task);
  Future<void> deleteTask(String userId, String taskId);
  Future<void> toggleTaskCompletion(String userId, String taskId, bool isCompleted);
}
