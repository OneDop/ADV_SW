enum ExperienceLevel {
  BEGINNER,
  INTERMEDIATE,
  ADVANCED,
  EXPERT,
}

enum Role {
  USER,
  ADMIN,
}

class AddUserSkillRequest {
  final int skillId;
  final ExperienceLevel experienceLevel;

  AddUserSkillRequest({
    required this.skillId,
    required this.experienceLevel,
  });

  Map<String, dynamic> toJson() {
    return {
      'skillId': skillId,
      'experienceLevel': experienceLevel.name,
    };
  }
}

class UserSummaryResponse {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String? profilePictureUrl;

  UserSummaryResponse({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.profilePictureUrl,
  });

  factory UserSummaryResponse.fromJson(Map<String, dynamic> json) {
    return UserSummaryResponse(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      profilePictureUrl: json['profilePictureUrl'],
    );
  }
}

class ChangePasswordRequest {
  final String oldPassword;
  final String newPassword;

  ChangePasswordRequest({
    required this.oldPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    };
  }
}

class UpdateProfileRequest {
  final String firstName;
  final String lastName;
  final String bio;
  final String? profilePictureUrl;

  UpdateProfileRequest({
    required this.firstName,
    required this.lastName,
    required this.bio,
    this.profilePictureUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'bio': bio,
      'profilePictureUrl': profilePictureUrl,
    };
  }
}

class UserProfileResponse {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String bio;
  final String? profilePictureUrl;
  final bool isActive;
  final Role role;

  UserProfileResponse({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.bio,
    this.profilePictureUrl,
    required this.isActive,
    required this.role,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
      id: json['id'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      bio: json['bio'],
      profilePictureUrl: json['profilePictureUrl'],
      isActive: json['isActive'],
      role: Role.values.byName(json['role']),
    );
  }
}

class UserSkillResponse {
  final int id;
  final int userId;
  final int skillId;
  final String skillName;
  final ExperienceLevel experienceLevel;

  UserSkillResponse({
    required this.id,
    required this.userId,
    required this.skillId,
    required this.skillName,
    required this.experienceLevel,
  });

  factory UserSkillResponse.fromJson(Map<String, dynamic> json) {
    return UserSkillResponse(
      id: json['id'],
      userId: json['userId'],
      skillId: json['skillId'],
      skillName: json['skillName'],
      experienceLevel: ExperienceLevel.values.byName(json['experienceLevel']),
    );
  }
}
