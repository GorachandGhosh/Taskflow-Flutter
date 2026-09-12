import '../entities/task.dart';
import '../repositories/task_repository.dart';

class UpdateTask {
  final TaskRepository repository;

  UpdateTask(this.repository);

  Future<void> call(String userId, TaskEntity task) {
    return repository.updateTask(userId, task);
  }
}
