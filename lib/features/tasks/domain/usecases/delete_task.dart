import '../repositories/task_repository.dart';

class DeleteTask {
  final TaskRepository repository;

  DeleteTask(this.repository);

  Future<void> call(String userId, String taskId) {
    return repository.deleteTask(userId, taskId);
  }
}
