import 'package:advsw/mock/mock_data.dart';
import 'package:advsw/models/search_model.dart';
import 'package:advsw/models/user_model.dart';

class SearchService {
  Future<List<SearchUserResult>> searchUsersByName(String name) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final lower = name.toLowerCase();
    return MockData.searchableUsers.where((u) {
      return '${u.firstName} ${u.lastName}'.toLowerCase().contains(lower) ||
          u.email.toLowerCase().contains(lower);
    }).toList();
  }

  Future<List<SearchUserResult>> searchUsersBySkill(int skillId,
      {ExperienceLevel? experienceLevel}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final skill = MockData.allSkills.firstWhere(
      (s) => s.id == skillId,
      orElse: () => throw Exception('Skill not found'),
    );
    return MockData.searchableUsers.where((u) {
      return u.skills.any((s) {
        final nameMatch = s.skillName == skill.name;
        if (!nameMatch) return false;
        if (experienceLevel != null) {
          return s.experienceLevel == experienceLevel.name;
        }
        return true;
      });
    }).toList();
  }

  Future<List<SearchUserResult>> recommendUsersBySkills(List<int> skillIds) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final skillNames = MockData.allSkills
        .where((s) => skillIds.contains(s.id))
        .map((s) => s.name)
        .toSet();
    return MockData.searchableUsers.where((u) {
      return u.skills.any((s) => skillNames.contains(s.skillName));
    }).toList();
  }

  Future<List<SearchUserResult>> searchUsers(
      {String? name, List<int>? skillIds}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    var results = List<SearchUserResult>.from(MockData.searchableUsers);
    if (name != null && name.isNotEmpty) {
      final lower = name.toLowerCase();
      results = results.where((u) =>
          '${u.firstName} ${u.lastName}'.toLowerCase().contains(lower)).toList();
    }
    if (skillIds != null && skillIds.isNotEmpty) {
      final skillNames = MockData.allSkills
          .where((s) => skillIds.contains(s.id))
          .map((s) => s.name)
          .toSet();
      results = results.where((u) =>
          u.skills.any((s) => skillNames.contains(s.skillName))).toList();
    }
    return results;
  }

  Future<List<SearchProjectResult>> browseOpenProjects({String? name}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (name == null || name.isEmpty) return List.from(MockData.searchableProjects);
    final lower = name.toLowerCase();
    return MockData.searchableProjects
        .where((p) => p.name.toLowerCase().contains(lower))
        .toList();
  }
}
