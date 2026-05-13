import 'package:advsw/models/task_model.dart';
import 'package:advsw/services/api_client.dart';

class TaskService {
  final ApiClient _apiClient = ApiClient();

  /// POST /api/tasks?projectId={projectId}
  Future<TaskResponse> createTask(int projectId, CreateTaskRequest request) async {
    try {
      final response = await _apiClient.post(
        '/tasks',
        data: request.toJson(),
        // Spring controller uses @RequestParam for projectId
        queryParameters: {'projectId': projectId},
      );
      return TaskResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// PATCH /api/tasks/{id}/assign?assigneeId={assigneeId}
  Future<TaskResponse> assignTask(int id, int assigneeId) async {
    try {
      final response = await _apiClient.patch(
        '/tasks/$id/assign',
        queryParameters: {'assigneeId': assigneeId},
      );
      return TaskResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// PATCH /api/tasks/{id}/status?status={status}
  Future<TaskResponse> updateTaskStatus(int id, TaskStatus status) async {
    try {
      final response = await _apiClient.patch(
        '/tasks/$id/status',
        queryParameters: {'status': status.name},
      );
      return TaskResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// GET /api/tasks/project/{projectId}
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
