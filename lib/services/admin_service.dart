import 'package:advsw/models/admin_model.dart';
import 'package:advsw/services/api_client.dart';

class AdminService {
  final ApiClient _apiClient = ApiClient();

  /// GET /api/admin/stats
  Future<AdminStats> getStats() async {
    try {
      final response = await _apiClient.get('/admin/stats');
      return AdminStats.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// GET /api/admin/users
  Future<List<AdminUser>> getAllUsers() async {
    try {
      final response = await _apiClient.get('/admin/users');
      final List<dynamic> data = response.data;
      return data.map((json) => AdminUser.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// PATCH /api/admin/users/{id}/status  — toggles isActive (block/unblock)
  Future<AdminUser> toggleUserStatus(int id) async {
    try {
      final response = await _apiClient.patch('/admin/users/$id/status');
      return AdminUser.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// PATCH /api/admin/users/{id}/role  — promotes user to ADMIN
  Future<AdminUser> promoteUser(int id) async {
    try {
      final response = await _apiClient.patch('/admin/users/$id/role');
      return AdminUser.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// GET /api/admin/projects
  Future<List<AdminProject>> getAllProjects() async {
    try {
      final response = await _apiClient.get('/admin/projects');
      final List<dynamic> data = response.data;
      return data.map((json) => AdminProject.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// PATCH /api/admin/projects/{id}/status  — toggles isDeleted (hide/show)
  Future<AdminProject> toggleProjectStatus(int id) async {
    try {
      final response = await _apiClient.patch('/admin/projects/$id/status');
      return AdminProject.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
