import 'package:advsw/models/task_model.dart';
import 'package:advsw/services/api_client.dart';

class TaskService {
  final ApiClient _apiClient = ApiClient();

  Future<TaskResponse> createTask(int projectId, CreateTaskRequest request) async {
    try {
      final response = await _apiClient.post(
        '/tasks',
        data: request.toJson(),
        queryParameters: {'projectId': projectId},
      );
      return TaskResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<TaskResponse> assignTask(int id, int assigneeId) async {
    try {
      final request = AssignTaskRequest(assigneeId: assigneeId);
      final response = await _apiClient.patch('/tasks/$id/assign', data: request.toJson());
      return TaskResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<TaskResponse> updateTaskStatus(int id, TaskStatus status) async {
    try {
      final request = UpdateTaskStatusRequest(status: status);
      final response = await _apiClient.patch('/tasks/$id/status', data: request.toJson());
      return TaskResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<TaskResponse> updateTask(int id, UpdateTaskRequest request) async {
    try {
      final response = await _apiClient.patch('/tasks/$id', data: request.toJson());
      return TaskResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> softDeleteTask(int id) async {
    try {
      await _apiClient.delete('/tasks/$id');
    } catch (e) {
      rethrow;
    }
  }

  Future<List<TaskResponse>> getTasksByProject(int projectId) async {
    try {
      final response = await _apiClient.get('/tasks/project/$projectId');
      final List<dynamic> data = response.data;
      return data.map((json) => TaskResponse.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
