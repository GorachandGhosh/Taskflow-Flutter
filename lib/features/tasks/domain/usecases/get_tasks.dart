import '../entities/task.dart';
import '../repositories/task_repository.dart';

class GetTasks {
  final TaskRepository repository;

  GetTasks(this.repository);

  Stream<List<TaskEntity>> call(String userId) {
    return repository.getTasks(userId);
  }
}
