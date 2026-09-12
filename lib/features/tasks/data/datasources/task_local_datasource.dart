import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/task_model.dart';

/// Local cache datasource using SharedPreferences for offline-first support.
abstract class TaskLocalDataSource {
  Future<List<TaskModel>> getCachedTasks(String userId);
  Future<void> cacheTasks(String userId, List<TaskModel> tasks);
  Future<void> clearCache(String userId);
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final SharedPreferences? _prefs;

  TaskLocalDataSourceImpl({SharedPreferences? prefs}) : _prefs = prefs;

  String _cacheKey(String userId) => 'cached_tasks_$userId';

  Future<SharedPreferences> _getPrefs() async {
    return _prefs ?? await SharedPreferences.getInstance();
  }

  @override
  Future<List<TaskModel>> getCachedTasks(String userId) async {
    try {
      final prefs = await _getPrefs();
      final jsonString = prefs.getString(_cacheKey(userId));
      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        return jsonList
            .map((item) => TaskModel.fromMap(item as Map<String, dynamic>, item['id'] ?? ''))
            .toList();
      }
      return [];
    } catch (e) {
      throw CacheException('Failed to read cached tasks: $e');
    }
  }

  @override
  Future<void> cacheTasks(String userId, List<TaskModel> tasks) async {
    try {
      final prefs = await _getPrefs();
      final list = tasks.map((task) {
        return {
          'id': task.id,
          'title': task.title,
          'description': task.description,
          'dueDate': task.dueDate.toIso8601String(),
          'priority': task.priority.label,
          'isCompleted': task.isCompleted,
          'createdAt': task.createdAt.toIso8601String(),
          'updatedAt': task.updatedAt.toIso8601String(),
        };
      }).toList();
      await prefs.setString(_cacheKey(userId), jsonEncode(list));
    } catch (e) {
      throw CacheException('Failed to cache tasks: $e');
    }
  }

  @override
  Future<void> clearCache(String userId) async {
    try {
      final prefs = await _getPrefs();
      await prefs.remove(_cacheKey(userId));
    } catch (e) {
      throw CacheException('Failed to clear cache: $e');
    }
  }
}
