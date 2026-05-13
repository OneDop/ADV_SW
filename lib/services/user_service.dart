import 'package:advsw/models/user_model.dart';
import 'package:advsw/services/api_client.dart';
import 'package:dio/dio.dart';

class UserService {
  final ApiClient _apiClient = ApiClient();

  /// GET /api/users/me
  Future<UserProfileResponse> getCurrentUserProfile() async {
    try {
      final response = await _apiClient.get('/users/me');
      return UserProfileResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// GET /api/users/{id}
  Future<UserProfileResponse> getProfile(int id) async {
    try {
      final response = await _apiClient.get('/users/$id');
      return UserProfileResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// PUT /api/users/me
  Future<UserProfileResponse> updateProfile(UpdateProfileRequest request) async {
    try {
      final response = await _apiClient.patch('/users/me', data: request.toJson());
      return UserProfileResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// PUT /api/users/me/password
  Future<void> changePassword(ChangePasswordRequest request) async {
    try {
      await _apiClient.patch('/users/me/password', data: request.toJson());
    } catch (e) {
      rethrow;
    }
  }

  /// POST /api/users/me/profile-picture
  Future<UserProfileResponse> uploadProfilePicture(String filePath) async {
    try {
      String fileName = filePath.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(filePath, filename: fileName),
      });

      final response = await _apiClient.post('/users/me/profile-picture', data: formData);
      return UserProfileResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// POST /api/users/me/skills
  Future<UserSkillResponse> addSkill(AddUserSkillRequest request) async {
    try {
      final response = await _apiClient.post('/users/me/skills', data: request.toJson());
      return UserSkillResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// DELETE /api/users/me/skills/{skillId}
  Future<void> removeSkill(int skillId) async {
    try {
      await _apiClient.delete('/users/me/skills/$skillId');
    } catch (e) {
      rethrow;
    }
  }

  /// GET /api/users/me/skills
  Future<List<UserSkillResponse>> getSkills() async {
    try {
      final response = await _apiClient.get('/users/me/skills');
      List<dynamic> data = response.data;
      return data.map((json) => UserSkillResponse.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
