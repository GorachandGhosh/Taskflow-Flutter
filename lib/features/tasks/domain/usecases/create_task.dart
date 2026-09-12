import '../entities/task.dart';
import '../repositories/task_repository.dart';

class CreateTask {
  final TaskRepository repository;

  CreateTask(this.repository);

  Future<void> call(String userId, TaskEntity task) {
    return repository.createTask(userId, task);
  }
}
