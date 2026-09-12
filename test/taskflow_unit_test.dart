import 'package:flutter_test/flutter_test.dart';
import 'package:taskflow/core/utils/validators.dart';
import 'package:taskflow/core/utils/date_formatter.dart';
import 'package:taskflow/features/tasks/domain/entities/task.dart';
import 'package:taskflow/features/tasks/data/models/task_model.dart';

void main() {
  group('Validators Unit Tests', () {
    test('validateEmail returns null for valid email', () {
      expect(Validators.validateEmail('user@whatbytes.com'), isNull);
      expect(Validators.validateEmail('alex.doe+gig@test.co'), isNull);
    });

    test('validateEmail returns error for invalid or empty email', () {
      expect(Validators.validateEmail(null), isNotNull);
      expect(Validators.validateEmail(''), isNotNull);
      expect(Validators.validateEmail('not-an-email'), isNotNull);
      expect(Validators.validateEmail('user@.com'), isNotNull);
    });

    test('validatePassword validates minimum 6 characters', () {
      expect(Validators.validatePassword(null), isNotNull);
      expect(Validators.validatePassword('12345'), isNotNull);
      expect(Validators.validatePassword('123456'), isNull);
      expect(Validators.validatePassword('securePassword123!'), isNull);
    });

    test('validateConfirmPassword checks matching passwords', () {
      expect(Validators.validateConfirmPassword('secret123', 'secret123'), isNull);
      expect(Validators.validateConfirmPassword('wrong', 'secret123'), isNotNull);
      expect(Validators.validateConfirmPassword('', 'secret123'), isNotNull);
    });

    test('validateTitle and validateDescription check non-empty input', () {
      expect(Validators.validateTitle('Deliver gig order'), isNull);
      expect(Validators.validateTitle('  '), isNotNull);
      expect(Validators.validateDescription('Client requested rush delivery'), isNull);
      expect(Validators.validateDescription(''), isNotNull);
    });
  });

  group('Task Entity & Model Tests', () {
    final testDate = DateTime(2026, 9, 13, 14, 0);
    final taskEntity = TaskEntity(
      id: 'task_001',
      title: 'Complete Flutter Assignment',
      description: 'Finish authentication and CRUD implementation',
      dueDate: testDate,
      priority: TaskPriority.high,
      isCompleted: false,
      createdAt: testDate,
      updatedAt: testDate,
    );

    test('TaskModel converts to and from map properly', () {
      final model = TaskModel.fromEntity(taskEntity);
      expect(model.id, equals('task_001'));
      expect(model.priority, equals(TaskPriority.high));
      expect(model.isCompleted, isFalse);

      final map = model.toFirestore();
      expect(map['title'], equals('Complete Flutter Assignment'));
      expect(map['priority'], equals('High'));
      expect(map['isCompleted'], isFalse);
    });

    test('TaskEntity copyWith updates properties immutably', () {
      final updated = taskEntity.copyWith(isCompleted: true);
      expect(updated.isCompleted, isTrue);
      expect(taskEntity.isCompleted, isFalse); // original intact
    });
  });

  group('DateFormatter & Sorting Tests', () {
    test('formatDueDate correctly computes Today and Tomorrow', () {
      final now = DateTime.now();
      expect(DateFormatter.formatDueDate(now), equals('Today'));

      final tomorrow = now.add(const Duration(days: 1));
      expect(DateFormatter.formatDueDate(tomorrow), equals('Tomorrow'));
    });

    test('Ascending due date sorting arranges earlier tasks first', () {
      final t1 = TaskEntity(
        id: '1',
        title: 'Task Due Later',
        description: '',
        dueDate: DateTime(2026, 9, 20),
        priority: TaskPriority.medium,
        isCompleted: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final t2 = TaskEntity(
        id: '2',
        title: 'Task Due Sooner',
        description: '',
        dueDate: DateTime(2026, 9, 15),
        priority: TaskPriority.high,
        isCompleted: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final tasks = [t1, t2];
      tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));

      expect(tasks.first.id, equals('2'));
      expect(tasks.last.id, equals('1'));
    });
  });
}
