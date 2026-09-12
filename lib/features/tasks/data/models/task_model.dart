import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/task.dart';

/// Data layer representation of Task with Firestore mapping.
class TaskModel extends TaskEntity {
  const TaskModel({
    required super.id,
    required super.title,
    required super.description,
    required super.dueDate,
    required super.priority,
    required super.isCompleted,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Factory constructor to convert Firestore DocumentSnapshot to TaskModel
  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return TaskModel(
      id: doc.id,
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      dueDate: data['dueDate'] is Timestamp
          ? (data['dueDate'] as Timestamp).toDate()
          : (DateTime.tryParse(data['dueDate']?.toString() ?? '') ?? DateTime.now()),
      priority: TaskPriority.fromString(data['priority'] as String? ?? 'low'),
      isCompleted: data['isCompleted'] as bool? ?? false,
      createdAt: data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : (DateTime.tryParse(data['createdAt']?.toString() ?? '') ?? DateTime.now()),
      updatedAt: data['updatedAt'] is Timestamp
          ? (data['updatedAt'] as Timestamp).toDate()
          : (DateTime.tryParse(data['updatedAt']?.toString() ?? '') ?? DateTime.now()),
    );
  }

  /// Factory to convert JSON/Map to TaskModel
  factory TaskModel.fromMap(Map<String, dynamic> map, String id) {
    return TaskModel(
      id: id,
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      dueDate: map['dueDate'] is Timestamp
          ? (map['dueDate'] as Timestamp).toDate()
          : DateTime.parse(map['dueDate'].toString()),
      priority: TaskPriority.fromString(map['priority'] as String? ?? 'low'),
      isCompleted: map['isCompleted'] as bool? ?? false,
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.parse(map['createdAt'].toString()),
      updatedAt: map['updatedAt'] is Timestamp
          ? (map['updatedAt'] as Timestamp).toDate()
          : DateTime.parse(map['updatedAt'].toString()),
    );
  }

  /// Converts TaskModel to a Firestore-compatible document Map
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'dueDate': Timestamp.fromDate(dueDate),
      'priority': priority.label,
      'isCompleted': isCompleted,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Creates a TaskModel from a TaskEntity
  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      dueDate: entity.dueDate,
      priority: entity.priority,
      isCompleted: entity.isCompleted,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
