import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/task_model.dart';

/// Abstract contract for remote task operations on Cloud Firestore.
abstract class TaskRemoteDataSource {
  Stream<List<TaskModel>> getTasks(String userId);
  Future<void> createTask(String userId, TaskModel task);
  Future<void> updateTask(String userId, TaskModel task);
  Future<void> deleteTask(String userId, String taskId);
  Future<void> toggleTaskCompletion(String userId, String taskId, bool isCompleted);
}

/// Firestore implementation with strict user isolation: users/{userId}/tasks/{taskId}.
class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final FirebaseFirestore _firestore;

  TaskRemoteDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _userTasksRef(String userId) {
    return _firestore.collection('users').doc(userId).collection('tasks');
  }

  @override
  Stream<List<TaskModel>> getTasks(String userId) {
    try {
      return _userTasksRef(userId)
          .orderBy('dueDate', descending: false)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList();
      });
    } catch (e) {
      throw ServerException('Failed to fetch tasks: $e');
    }
  }

  @override
  Future<void> createTask(String userId, TaskModel task) async {
    try {
      final data = task.toFirestore();
      if (task.id.isNotEmpty) {
        await _userTasksRef(userId).doc(task.id).set(data);
      } else {
        await _userTasksRef(userId).add(data);
      }
    } catch (e) {
      throw ServerException('Failed to create task: $e');
    }
  }

  @override
  Future<void> updateTask(String userId, TaskModel task) async {
    try {
      final data = task.toFirestore();
      data['updatedAt'] = Timestamp.now();
      await _userTasksRef(userId).doc(task.id).update(data);
    } catch (e) {
      throw ServerException('Failed to update task: $e');
    }
  }

  @override
  Future<void> deleteTask(String userId, String taskId) async {
    try {
      await _userTasksRef(userId).doc(taskId).delete();
    } catch (e) {
      throw ServerException('Failed to delete task: $e');
    }
  }

  @override
  Future<void> toggleTaskCompletion(
    String userId,
    String taskId,
    bool isCompleted,
  ) async {
    try {
      await _userTasksRef(userId).doc(taskId).update({
        'isCompleted': isCompleted,
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      throw ServerException('Failed to toggle task completion: $e');
    }
  }
}
