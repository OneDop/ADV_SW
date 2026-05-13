import 'package:advsw/models/search_model.dart';
import 'package:advsw/models/user_model.dart';
import 'package:advsw/services/api_client.dart';

class SearchService {
  final ApiClient _apiClient = ApiClient();

  /// GET /api/search/users?name={name}
  Future<List<SearchUserResult>> searchUsersByName(String name) async {
    try {
      final response = await _apiClient.get(
        '/search/users',
        queryParameters: {'name': name},
      );
      final List<dynamic> data = response.data;
      return data.map((json) => SearchUserResult.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// GET /api/search/users/skill?skillId={skillId}&experienceLevel={experienceLevel}
  Future<List<SearchUserResult>> searchUsersBySkill(int skillId, {ExperienceLevel? experienceLevel}) async {
    try {
      final Map<String, dynamic> params = {'skillId': skillId};
      if (experienceLevel != null) {
        params['experienceLevel'] = experienceLevel.name;
      }
      final response = await _apiClient.get(
        '/search/users/skill',
        queryParameters: params,
      );
      final List<dynamic> data = response.data;
      return data.map((json) => SearchUserResult.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// GET /api/search/users/recommend?skillIds={skillIds}
  Future<List<SearchUserResult>> recommendUsersBySkills(List<int> skillIds) async {
    try {
      final response = await _apiClient.get(
        '/search/users/recommend',
        queryParameters: {'skillIds': skillIds.join(',')},
      );
      final List<dynamic> data = response.data;
      return data.map((json) => SearchUserResult.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// GET /api/search/projects
  Future<List<SearchProjectResult>> browseOpenProjects() async {
    try {
      final response = await _apiClient.get('/search/projects');
      final List<dynamic> data = response.data;
      return data.map((json) => SearchProjectResult.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
