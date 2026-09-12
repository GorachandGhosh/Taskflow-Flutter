import '../repositories/task_repository.dart';

class ToggleTask {
  final TaskRepository repository;

  ToggleTask(this.repository);

  Future<void> call(String userId, String taskId, bool isCompleted) {
    return repository.toggleTaskCompletion(userId, taskId, isCompleted);
  }
}
