import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taskflow/features/tasks/domain/entities/task.dart';
import 'package:taskflow/features/tasks/domain/usecases/create_task.dart';
import 'package:taskflow/features/tasks/domain/usecases/delete_task.dart';
import 'package:taskflow/features/tasks/domain/usecases/get_tasks.dart';
import 'package:taskflow/features/tasks/domain/usecases/toggle_task.dart';
import 'package:taskflow/features/tasks/domain/usecases/update_task.dart';
import 'package:taskflow/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:taskflow/features/tasks/presentation/bloc/task_event.dart';
import 'package:taskflow/features/tasks/presentation/bloc/task_state.dart';

class MockGetTasks extends Mock implements GetTasks {}
class MockCreateTask extends Mock implements CreateTask {}
class MockUpdateTask extends Mock implements UpdateTask {}
class MockDeleteTask extends Mock implements DeleteTask {}
class MockToggleTask extends Mock implements ToggleTask {}

void main() {
  late MockGetTasks mockGetTasks;
  late MockCreateTask mockCreateTask;
  late MockUpdateTask mockUpdateTask;
  late MockDeleteTask mockDeleteTask;
  late MockToggleTask mockToggleTask;
  late TaskBloc taskBloc;

  final now = DateTime(2026, 9, 15, 10, 0);
  final task1 = TaskEntity(
    id: 't1',
    title: 'Deliver grocery batch',
    description: 'Downtown delivery route',
    dueDate: now.add(const Duration(hours: 2)),
    priority: TaskPriority.high,
    isCompleted: false,
    createdAt: now,
    updatedAt: now,
  );
  final task2 = TaskEntity(
    id: 't2',
    title: 'Submit mileage log',
    description: 'Weekly expense submission',
    dueDate: now.add(const Duration(days: 1)),
    priority: TaskPriority.low,
    isCompleted: true,
    createdAt: now,
    updatedAt: now,
  );

  setUp(() {
    mockGetTasks = MockGetTasks();
    mockCreateTask = MockCreateTask();
    mockUpdateTask = MockUpdateTask();
    mockDeleteTask = MockDeleteTask();
    mockToggleTask = MockToggleTask();

    taskBloc = TaskBloc(
      getTasks: mockGetTasks,
      createTask: mockCreateTask,
      updateTask: mockUpdateTask,
      deleteTask: mockDeleteTask,
      toggleTask: mockToggleTask,
    );
  });

  tearDown(() {
    taskBloc.close();
  });

  group('TaskBloc Tests', () {
    test('initial state has empty task lists and default filters', () {
      expect(taskBloc.state.allTasks, isEmpty);
      expect(taskBloc.state.filteredTasks, isEmpty);
      expect(taskBloc.state.priorityFilter, equals(TaskPriorityFilter.all));
      expect(taskBloc.state.statusFilter, equals(TaskStatusFilter.all));
    });

    blocTest<TaskBloc, TaskState>(
      'updates task lists when TasksUpdated is received and sorts by dueDate',
      build: () => taskBloc,
      act: (bloc) => bloc.add(TasksUpdated([task2, task1])),
      expect: () => [
        predicate<TaskState>((state) {
          // task1 is due earlier than task2, so it should be first in sorted order
          return state.allTasks.length == 2 &&
              state.filteredTasks.length == 2 &&
              state.filteredTasks.first.id == 't1';
        }),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'filters tasks correctly by priority',
      build: () => taskBloc,
      seed: () => TaskState(allTasks: [task1, task2], filteredTasks: [task1, task2]),
      act: (bloc) => bloc.add(const FilterTasksEvent(priorityFilter: 'high')),
      expect: () => [
        predicate<TaskState>((state) {
          return state.priorityFilter == TaskPriorityFilter.high &&
              state.filteredTasks.length == 1 &&
              state.filteredTasks.first.id == 't1';
        }),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'filters tasks correctly by status (completed)',
      build: () => taskBloc,
      seed: () => TaskState(allTasks: [task1, task2], filteredTasks: [task1, task2]),
      act: (bloc) => bloc.add(const FilterTasksEvent(statusFilter: 'completed')),
      expect: () => [
        predicate<TaskState>((state) {
          return state.statusFilter == TaskStatusFilter.completed &&
              state.filteredTasks.length == 1 &&
              state.filteredTasks.first.id == 't2';
        }),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'searches tasks by title and description case-insensitively',
      build: () => taskBloc,
      seed: () => TaskState(allTasks: [task1, task2], filteredTasks: [task1, task2]),
      act: (bloc) => bloc.add(const SearchTasksEvent('grocery')),
      expect: () => [
        predicate<TaskState>((state) {
          return state.searchQuery == 'grocery' &&
              state.filteredTasks.length == 1 &&
              state.filteredTasks.first.id == 't1';
        }),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'clears all active filters and search query',
      build: () => taskBloc,
      seed: () => TaskState(
        allTasks: [task1, task2],
        filteredTasks: [task1],
        priorityFilter: TaskPriorityFilter.high,
        statusFilter: TaskStatusFilter.incomplete,
        searchQuery: 'grocery',
      ),
      act: (bloc) => bloc.add(ClearFiltersEvent()),
      expect: () => [
        predicate<TaskState>((state) {
          return state.priorityFilter == TaskPriorityFilter.all &&
              state.statusFilter == TaskStatusFilter.all &&
              state.searchQuery == '' &&
              state.filteredTasks.length == 2;
        }),
      ],
    );
  });
}
