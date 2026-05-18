import 'package:advsw/mock/mock_data.dart';
import 'package:advsw/models/skill_model.dart';
import 'package:advsw/models/user_model.dart';

class SkillService {
  Future<List<SkillResponse>> getAllSkills() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(MockData.allSkills);
  }

  Future<SkillResponse> createSkill(CreateSkillRequest request) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final skill = SkillResponse(
      id: DateTime.now().millisecondsSinceEpoch % 100000,
      name: request.name,
    );
    MockData.allSkills.add(skill);
    return skill;
  }

  Future<UserSkillResponse> addSkillToUser(AddUserSkillRequest request) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final skill = MockData.allSkills.firstWhere(
      (s) => s.id == request.skillId,
      orElse: () => throw Exception('Skill not found'),
    );
    final userSkill = UserSkillResponse(
      id: DateTime.now().millisecondsSinceEpoch % 100000,
      userId: MockData.currentUserId,
      skillId: skill.id,
      skillName: skill.name,
      experienceLevel: request.experienceLevel,
    );
    return userSkill;
  }

  Future<void> removeSkillFromUser(int skillId) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  Future<List<UserSkillResponse>> getUserSkills(int userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (userId == MockData.currentUserId) return MockData.currentUser.skills;
    return MockData.otherUsers[userId]?.skills ?? [];
  }
}
