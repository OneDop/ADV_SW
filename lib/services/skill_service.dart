import 'package:advsw/models/skill_model.dart';
import 'package:advsw/models/user_model.dart';
import 'package:advsw/services/api_client.dart';

class SkillService {
  final ApiClient _apiClient = ApiClient();

  /// GET /api/skills
  Future<List<SkillResponse>> getAllSkills() async {
    try {
      final response = await _apiClient.get('/skills');
      final List<dynamic> data = response.data;
      return data.map((json) => SkillResponse.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// POST /api/skills
  Future<SkillResponse> createSkill(CreateSkillRequest request) async {
    try {
      final response = await _apiClient.post('/skills', data: request.toJson());
      return SkillResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// POST /api/skills/user
  Future<UserSkillResponse> addSkillToUser(AddUserSkillRequest request) async {
    try {
      final response = await _apiClient.post('/skills/user', data: request.toJson());
      return UserSkillResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// DELETE /api/skills/user/{skillId}
  Future<void> removeSkillFromUser(int skillId) async {
    try {
      await _apiClient.delete('/skills/user/$skillId');
    } catch (e) {
      rethrow;
    }
  }

  /// GET /api/skills/user/{userId}
  Future<List<UserSkillResponse>> getUserSkills(int userId) async {
    try {
      final response = await _apiClient.get('/skills/user/$userId');
      final List<dynamic> data = response.data;
      return data.map((json) => UserSkillResponse.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
