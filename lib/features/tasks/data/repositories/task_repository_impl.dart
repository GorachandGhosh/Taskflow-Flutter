import 'dart:async';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_local_datasource.dart';
import '../datasources/task_remote_datasource.dart';
import '../models/task_model.dart';

/// Implementation of TaskRepository managing the interaction between TaskRemoteDataSource,
/// optional TaskLocalDataSource for offline-first support, and domain entities.
class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;
  final TaskLocalDataSource? localDataSource;

  TaskRepositoryImpl({
    required this.remoteDataSource,
    this.localDataSource,
  });

  @override
  Stream<List<TaskEntity>> getTasks(String userId) {
    try {
      final remoteStream = remoteDataSource.getTasks(userId);

      // Listen to remote stream and update local cache seamlessly
      return remoteStream.map((tasks) {
        if (localDataSource != null) {
          localDataSource!.cacheTasks(userId, tasks).catchError((_) {});
        }
        return tasks;
      });
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> createTask(String userId, TaskEntity task) async {
    try {
      final model = TaskModel.fromEntity(task);
      await remoteDataSource.createTask(userId, model);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> updateTask(String userId, TaskEntity task) async {
    try {
      final model = TaskModel.fromEntity(task);
      await remoteDataSource.updateTask(userId, model);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> deleteTask(String userId, String taskId) async {
    try {
      await remoteDataSource.deleteTask(userId, taskId);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> toggleTaskCompletion(
    String userId,
    String taskId,
    bool isCompleted,
  ) async {
    try {
      await remoteDataSource.toggleTaskCompletion(userId, taskId, isCompleted);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
