import 'package:advsw/mock/mock_data.dart';
import 'package:advsw/models/user_model.dart';

class UserService {
  Future<UserProfileResponse> getCurrentUserProfile() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockData.currentUser;
  }

  Future<UserProfileResponse> getProfile(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (id == MockData.currentUserId) return MockData.currentUser;
    final user = MockData.otherUsers[id];
    if (user == null) throw Exception('User not found');
    return user;
  }

  Future<UserProfileResponse> updateProfile(UpdateProfileRequest request) async {
    await Future.delayed(const Duration(milliseconds: 400));
    MockData.currentUser = UserProfileResponse(
      id: MockData.currentUser.id,
      email: MockData.currentUser.email,
      firstName: request.firstName,
      lastName: request.lastName,
      bio: request.bio,
      profilePictureUrl: request.profilePictureUrl ?? MockData.currentUser.profilePictureUrl,
      role: MockData.currentUser.role,
      availabilityStatus: request.availabilityStatus,
      skills: MockData.currentUser.skills,
      pastProjects: MockData.currentUser.pastProjects,
      averageRating: MockData.currentUser.averageRating,
    );
    return MockData.currentUser;
  }

  Future<UserProfileResponse> updatePortfolio(UpdatePortfolioRequest request) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return MockData.currentUser;
  }

  Future<void> changePassword(ChangePasswordRequest request) async {
    await Future.delayed(const Duration(milliseconds: 400));
  }

  Future<UserProfileResponse> uploadProfilePicture(String filePath) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return MockData.currentUser;
  }

  Future<UserSkillResponse> addSkill(AddUserSkillRequest request) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final skill = MockData.allSkills.firstWhere(
      (s) => s.id == request.skillId,
      orElse: () => throw Exception('Skill not found'),
    );
    final newSkill = UserSkillResponse(
      id: DateTime.now().millisecondsSinceEpoch,
      userId: MockData.currentUserId,
      skillId: skill.id,
      skillName: skill.name,
      experienceLevel: request.experienceLevel,
    );
    MockData.currentUser = UserProfileResponse(
      id: MockData.currentUser.id,
      email: MockData.currentUser.email,
      firstName: MockData.currentUser.firstName,
      lastName: MockData.currentUser.lastName,
      bio: MockData.currentUser.bio,
      profilePictureUrl: MockData.currentUser.profilePictureUrl,
      role: MockData.currentUser.role,
      availabilityStatus: MockData.currentUser.availabilityStatus,
      skills: [...MockData.currentUser.skills, newSkill],
      pastProjects: MockData.currentUser.pastProjects,
      averageRating: MockData.currentUser.averageRating,
    );
    return newSkill;
  }

  Future<void> removeSkill(int skillId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    MockData.currentUser = UserProfileResponse(
      id: MockData.currentUser.id,
      email: MockData.currentUser.email,
      firstName: MockData.currentUser.firstName,
      lastName: MockData.currentUser.lastName,
      bio: MockData.currentUser.bio,
      profilePictureUrl: MockData.currentUser.profilePictureUrl,
      role: MockData.currentUser.role,
      availabilityStatus: MockData.currentUser.availabilityStatus,
      skills: MockData.currentUser.skills.where((s) => s.skillId != skillId).toList(),
      pastProjects: MockData.currentUser.pastProjects,
      averageRating: MockData.currentUser.averageRating,
    );
  }

  Future<List<UserSkillResponse>> getSkills() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return MockData.currentUser.skills;
  }
}
