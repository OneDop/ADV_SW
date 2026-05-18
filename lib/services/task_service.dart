import 'package:advsw/mock/mock_data.dart';
import 'package:advsw/models/task_model.dart';

class TaskService {
  Future<TaskResponse> createTask(int projectId, CreateTaskRequest request) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final task = TaskResponse(
      id: MockData.nextTaskId(),
      title: request.title,
      description: request.description,
      status: TaskStatus.TODO,
      deadline: request.deadline,
      projectId: projectId,
      isDeleted: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    MockData.tasksByProject.putIfAbsent(projectId, () => []).add(task);
    return task;
  }

  Future<TaskResponse> assignTask(int id, int assigneeId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mutateTask(id, (t) {
      String? name;
      if (assigneeId == MockData.currentUserId) {
        name = '${MockData.currentUser.firstName} ${MockData.currentUser.lastName}';
      } else {
        final u = MockData.otherUsers[assigneeId];
        name = u != null ? '${u.firstName} ${u.lastName}' : 'Unknown';
      }
      return TaskResponse(
        id: t.id, title: t.title, description: t.description,
        status: t.status, deadline: t.deadline, projectId: t.projectId,
        assigneeId: assigneeId, assigneeName: name,
        isDeleted: t.isDeleted, createdAt: t.createdAt, updatedAt: DateTime.now(),
      );
    });
  }

  Future<TaskResponse> updateTaskStatus(int id, TaskStatus status) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mutateTask(id, (t) => TaskResponse(
      id: t.id, title: t.title, description: t.description,
      status: status, deadline: t.deadline, projectId: t.projectId,
      assigneeId: t.assigneeId, assigneeName: t.assigneeName,
      isDeleted: t.isDeleted, createdAt: t.createdAt, updatedAt: DateTime.now(),
    ));
  }

  Future<TaskResponse> updateTask(int id, UpdateTaskRequest request) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _mutateTask(id, (t) {
      String? name;
      if (request.assigneeId != null) {
        if (request.assigneeId == MockData.currentUserId) {
          name = '${MockData.currentUser.firstName} ${MockData.currentUser.lastName}';
        } else {
          final u = MockData.otherUsers[request.assigneeId!];
          name = u != null ? '${u.firstName} ${u.lastName}' : null;
        }
      } else {
        name = t.assigneeName;
      }
      return TaskResponse(
        id: t.id, title: request.title, description: request.description,
        status: request.status, deadline: request.deadline, projectId: t.projectId,
        assigneeId: request.assigneeId ?? t.assigneeId,
        assigneeName: name,
        isDeleted: t.isDeleted, createdAt: t.createdAt, updatedAt: DateTime.now(),
      );
    });
  }

  Future<void> softDeleteTask(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    for (final list in MockData.tasksByProject.values) {
      list.removeWhere((t) => t.id == id);
    }
  }

  Future<List<TaskResponse>> getTasksByProject(int projectId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(MockData.tasksByProject[projectId] ?? []);
  }

  TaskResponse _mutateTask(int id, TaskResponse Function(TaskResponse) transform) {
    for (final list in MockData.tasksByProject.values) {
      final idx = list.indexWhere((t) => t.id == id);
      if (idx != -1) {
        list[idx] = transform(list[idx]);
        return list[idx];
      }
    }
    throw Exception('Task not found');
  }
}
