import 'package:advsw/models/project_model.dart';
import 'package:advsw/services/api_client.dart';

class ProjectService {
  final ApiClient _apiClient = ApiClient();

  /// POST /api/projects
  Future<ProjectResponse> createProject(CreateProjectRequest request) async {
    try {
      final response = await _apiClient.post('/projects', data: request.toJson());
      return ProjectResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// PATCH /api/projects/{id}
  Future<ProjectResponse> updateProject(int id, UpdateProjectRequest request) async {
    try {
      final response = await _apiClient.patch('/projects/$id', data: request.toJson());
      return ProjectResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// DELETE /api/projects/{id}
  Future<void> softDeleteProject(int id) async {
    try {
      await _apiClient.delete('/projects/$id');
    } catch (e) {
      rethrow;
    }
  }

  /// GET /api/projects/{id}
  Future<ProjectResponse> getProjectById(int id) async {
    try {
      final response = await _apiClient.get('/projects/$id');
      return ProjectResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// GET /api/projects/my
  Future<List<ProjectResponse>> getMyProjects() async {
    try {
      final response = await _apiClient.get('/projects/my');
      final List<dynamic> data = response.data;
      return data.map((json) => ProjectResponse.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// GET /api/projects/browse
  Future<List<ProjectResponse>> browseAvailableProjects() async {
    try {
      final response = await _apiClient.get('/projects/browse');
      final List<dynamic> data = response.data;
      return data.map((json) => ProjectResponse.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
