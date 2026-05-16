import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:advsw/models/task_model.dart';
import 'package:advsw/services/task_service.dart';

/// Provider for TaskService
final taskServiceProvider = Provider<TaskService>((ref) {
  return TaskService();
});

/// AsyncNotifier to manage tasks for a specific project
class ProjectTasksNotifier extends FamilyAsyncNotifier<List<TaskResponse>, int> {
  @override
  FutureOr<List<TaskResponse>> build(int arg) async {
    return ref.watch(taskServiceProvider).getTasksByProject(arg);
  }

  /// Create a new task and add it to the local state
  Future<void> createTask(CreateTaskRequest request) async {
    state = await AsyncValue.guard(() async {
      final newTask = await ref.read(taskServiceProvider).createTask(arg, request);
      final currentTasks = state.value ?? [];
      return [...currentTasks, newTask];
    });
  }

  /// Update an existing task and update the local state
  Future<void> updateTask(int id, UpdateTaskRequest request) async {
    state = await AsyncValue.guard(() async {
      final updatedTask = await ref.read(taskServiceProvider).updateTask(id, request);
      final currentTasks = state.value ?? [];
      return currentTasks.map((t) => t.id == id ? updatedTask : t).toList();
    });
  }

  /// Update task status and update the local state
  Future<void> updateTaskStatus(int id, TaskStatus status) async {
    state = await AsyncValue.guard(() async {
      final updatedTask = await ref.read(taskServiceProvider).updateTaskStatus(id, status);
      final currentTasks = state.value ?? [];
      return currentTasks.map((t) => t.id == id ? updatedTask : t).toList();
    });
  }

  /// Assign task to a user and update the local state
  Future<void> assignTask(int id, int assigneeId) async {
    state = await AsyncValue.guard(() async {
      final updatedTask = await ref.read(taskServiceProvider).assignTask(id, assigneeId);
      final currentTasks = state.value ?? [];
      return currentTasks.map((t) => t.id == id ? updatedTask : t).toList();
    });
  }

  /// Soft delete a task and remove it from the local state
  Future<void> deleteTask(int id) async {
    state = await AsyncValue.guard(() async {
      await ref.read(taskServiceProvider).softDeleteTask(id);
      final currentTasks = state.value ?? [];
      return currentTasks.where((t) => t.id != id).toList();
    });
  }

  /// Refresh the task list for this project from the server
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(taskServiceProvider).getTasksByProject(arg));
  }
}

/// Provider for tasks of a specific project (indexed by projectId)
final projectTasksProvider = AsyncNotifierProvider.family<ProjectTasksNotifier, List<TaskResponse>, int>(
  ProjectTasksNotifier.new,
);
